import pandas as pd
from sqlalchemy import create_engine, text
import logging
import re
from typing import Dict, List, Optional, Tuple
import numpy as np

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def normalize_name(name: str) -> str:
    """Normalize a name to be database-friendly: lowercase, underscores, no special chars."""
    # Convert to lowercase
    name = name.lower()
    # Replace spaces and hyphens with underscores
    name = re.sub(r'[\s\-]+', '_', name)
    # Remove special characters except underscores
    name = re.sub(r'[^\w_]', '', name)
    # Ensure it starts with a letter or underscore
    if not name[0].isalpha() and name[0] != '_':
        name = 'table_' + name
    # Remove multiple underscores
    name = re.sub(r'_+', '_', name)
    # Remove trailing underscores
    name = name.rstrip('_')
    return name

# Comprehensive column mapping for regulatory analysis
column_mapping = {
    # Plant and Agent identifiers
    'Código SIC': 'codigo_sic',
    'Nombre Agente': 'agente_nombre',
    'Agente Representante': 'agente_nombre',
    'AGENTE COMPRADOR': 'agente_nombre',
    'COMPRADOR': 'agente_nombre',
    'PLANTA COMPRA': 'planta_nombre',
    'PLANTA': 'planta_nombre',
    'Nombre Recurso': 'planta_nombre',
    'Recurso': 'planta_nombre',
    'Planta': 'planta_nombre',

    # Date columns
    'FECHA': 'fecha',
    'FECHA INICIAL': 'fecha_inicial',
    'FECHA FINAL': 'fecha_final',
    'FECHA_DIA': 'fecha_dia',
    'Fecha Registro': 'fecha_registro',
    'Fecha Fin': 'fecha_fin',
    'Fecha': 'fecha_dia',

    # Energy measurements (kWh)
    'CANT_REGISTRADAS (kWh)': 'kwh_registrado',
    'CANT_DESPACHADADAS (kWh)': 'kwh_despachado',
    'KWH_DIA_TOTAL REGISTRADO': 'kwh_registrado',
    'DDVV(kWh) Verificada': 'kwh_verificado',
    'DDVV(kWh)': 'kwh_verificado',
    'DDV Verificada (kWh)': 'kwh_verificado',
    'DDV Registrada (kWh)': 'kwh_registrado',
    'kWh Registrado': 'kwh_registrado',
    'kWh Verificado': 'kwh_verificado',
    'kWh Despachado': 'kwh_despachado',

    # Financial columns (COP)
    'RRID (COP)': 'rrid_cop',
    ' RRID SIN ANILLOS (COP) ': 'rrid_sin_anillos_cop',
    'RRID sin Anillos (COP)': 'rrid_sin_anillos_cop',
    'Costo RRID (COP)': 'rrid_cop',

    # Additional columns
    'PB>PEA': 'pb_pea',
    'ActivacionOEF': 'activacion_oef',
    'Actividad': 'actividad',
    'Clasificación': 'clasificacion',
    'Estado': 'estado',
    'Estado Recurso': 'estado_recurso',
    'Tipo Generación': 'tipo_generacion',
    'Tipo Generacion': 'tipo_generacion',
    'Generación': 'tipo_generacion',

    # Market columns
    'Mercado Secundario Registrado (kWh)': 'kwh_registrado',
    'Mercado Secundario Despachado (kWh)': 'kwh_despachado',
    'MWh Registrado': 'mwh_registrado',
    'MWh Despachado': 'mwh_despachado',
    'MWh Verificado': 'mwh_verificado'
}

# Table-specific configurations for regulatory analysis
TABLE_CONFIGS = {
    'rrid_antes_066_24': {
        'required_columns': ['planta_nombre', 'rrid_cop', 'rrid_sin_anillos_cop'],
        'numeric_columns': ['rrid_cop', 'rrid_sin_anillos_cop'],
        'precision': 0,  # Round to whole numbers for COP currency
        'indexes': ['planta_nombre', 'rrid_cop', 'rrid_sin_anillos_cop']
    },
    'rrid_despues_066_24': {
        'required_columns': ['planta_nombre', 'rrid_cop', 'rrid_sin_anillos_cop'],
        'numeric_columns': ['rrid_cop', 'rrid_sin_anillos_cop'],
        'precision': 0,
        'indexes': ['planta_nombre', 'rrid_cop', 'rrid_sin_anillos_cop']
    },
    'ddv_reg_vs_ddv_ver': {
        'required_columns': ['planta_nombre', 'agente_nombre', 'fecha_dia', 'kwh_registrado', 'kwh_verificado'],
        'numeric_columns': ['kwh_registrado', 'kwh_verificado'],
        'date_columns': ['fecha_dia', 'fecha_inicial', 'fecha_final'],
        'precision': 0,  # kWh should be whole numbers
        'indexes': ['planta_nombre', 'agente_nombre', 'fecha_dia']
    },
    'ddv_verificada': {
        'required_columns': ['planta_nombre', 'agente_nombre', 'fecha_dia', 'kwh_verificado'],
        'numeric_columns': ['kwh_verificado'],
        'date_columns': ['fecha_dia', 'fecha_inicial', 'fecha_final'],
        'precision': 0,
        'indexes': ['planta_nombre', 'agente_nombre', 'fecha_dia']
    },
    'msec_reg_vs_msec_desp': {
        'required_columns': ['planta_nombre', 'agente_nombre', 'kwh_registrado', 'kwh_despachado'],
        'numeric_columns': ['kwh_registrado', 'kwh_despachado'],
        'precision': 0,
        'indexes': ['planta_nombre', 'agente_nombre']
    },
    'mapeo_recursos': {
        'required_columns': ['codigo_sic', 'agente_nombre', 'tipo_generacion'],
        'indexes': ['codigo_sic', 'agente_nombre', 'tipo_generacion']
    },
    'mapeo_agentes': {
        'required_columns': ['codigo_sic', 'agente_nombre', 'planta_nombre'],
        'indexes': ['codigo_sic', 'agente_nombre', 'planta_nombre']
    }
}

def validate_data_quality(df: pd.DataFrame, table_name: str) -> Tuple[bool, List[str]]:
    """Validate data quality for regulatory compliance."""
    issues = []
    config = TABLE_CONFIGS.get(table_name, {})

    # Check for required columns
    required_cols = config.get('required_columns', [])
    missing_cols = [col for col in required_cols if col not in df.columns]
    if missing_cols:
        issues.append(f"Missing required columns: {missing_cols}")

    # Check for null values in critical columns
    for col in required_cols:
        if col in df.columns:
            null_count = df[col].isnull().sum()
            if null_count > 0:
                issues.append(f"Column '{col}' has {null_count} null values")

    # Check for negative values in energy columns
    energy_cols = ['kwh_registrado', 'kwh_verificado', 'kwh_despachado', 'rrid_cop', 'rrid_sin_anillos_cop']
    for col in energy_cols:
        if col in df.columns:
            try:
                # Convert to numeric for comparison, handling errors gracefully
                numeric_col = pd.to_numeric(df[col], errors='coerce')
                negative_count = (numeric_col < 0).sum()
                if negative_count > 0:
                    issues.append(f"Column '{col}' has {negative_count} negative values")
            except Exception as e:
                issues.append(f"Error checking negative values in '{col}': {str(e)}")

    # Check date validity
    date_cols = config.get('date_columns', [])
    for col in date_cols:
        if col in df.columns:
            try:
                converted_dates = pd.to_datetime(df[col], errors='coerce')
                invalid_dates = converted_dates.isnull().sum()
                if invalid_dates > 0:
                    issues.append(f"Column '{col}' has {invalid_dates} invalid dates")
            except Exception as e:
                issues.append(f"Error validating dates in '{col}': {str(e)}")

    return len(issues) == 0, issues

def optimize_data_types(df: pd.DataFrame, table_name: str) -> pd.DataFrame:
    """Apply table-specific data type optimizations."""
    config = TABLE_CONFIGS.get(table_name, {})
    precision = config.get('precision', 2)

    # Optimize numeric columns
    numeric_cols = config.get('numeric_columns', [])
    for col in numeric_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors='coerce')
            if precision == 0:
                df[col] = df[col].round(0).astype('Int64')
            else:
                df[col] = df[col].round(precision)

    # Optimize date columns
    date_cols = config.get('date_columns', [])
    for col in date_cols:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors='coerce')

    # Convert other columns to appropriate types
    df = df.convert_dtypes()

    return df

def create_indexes(engine, table_name: str, columns: List[str]):
    """Create indexes for optimal query performance."""
    try:
        with engine.connect() as conn:
            for col in columns:
                if col in pd.read_sql(f"SELECT column_name FROM information_schema.columns WHERE table_name = '{table_name}'", conn).values.flatten():
                    index_name = f"idx_{table_name}_{col}"
                    conn.execute(text(f"CREATE INDEX IF NOT EXISTS {index_name} ON {table_name} ({col})"))
                    logging.info(f"Created index {index_name} on {table_name}({col})")
            conn.commit()
    except Exception as e:
        logging.warning(f"Could not create indexes for {table_name}: {e}")

def process_table_data(engine, df: pd.DataFrame, table_name: str, chunk_size: int = 10000):
    """Process and insert data in chunks for better performance."""
    try:
        # Validate data quality
        is_valid, issues = validate_data_quality(df, table_name)
        if not is_valid:
            logging.warning(f"Data quality issues in {table_name}: {'; '.join(issues)}")

        # Optimize data types
        df = optimize_data_types(df, table_name)

        # Log final data types
        logging.info(f"Final data types for table '{table_name}': {df.dtypes.to_dict()}")

        # Insert data in chunks for large datasets
        total_rows = len(df)
        logging.info(f"Inserting {total_rows} rows into {table_name}")

        if total_rows > chunk_size:
            for i in range(0, total_rows, chunk_size):
                chunk = df.iloc[i:i + chunk_size]
                chunk.to_sql(table_name, engine, if_exists='append', index=False)
                logging.info(f"Inserted chunk {i//chunk_size + 1}/{(total_rows-1)//chunk_size + 1}")
        else:
            df.to_sql(table_name, engine, if_exists='replace', index=False)

        # Create indexes for query optimization
        config = TABLE_CONFIGS.get(table_name, {})
        indexes = config.get('indexes', [])
        if indexes:
            create_indexes(engine, table_name, indexes)

        logging.info(f"Table '{table_name}' processed successfully.")

    except Exception as e:
        logging.error(f"Error processing table '{table_name}': {e}")
        raise

# PostgreSQL connection details
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'postgres'

# Create the connection string
connection_string = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'

try:
    # Create SQLAlchemy engine with optimized settings
    engine = create_engine(
        connection_string,
        pool_pre_ping=True,
        pool_recycle=3600,
        echo=False
    )
    logging.info("Database engine created successfully.")
except Exception as e:
    logging.error(f"Failed to create database engine: {e}")
    exit(1)

# Path to the Excel file
excel_file = 'data/Cantidades MS - DDV -RRID (2023-2024-2025).xlsx'

try:
    # Load the Excel file and get all sheet names
    xls = pd.ExcelFile(excel_file)
    sheet_names = xls.sheet_names
    logging.info(f"Excel file loaded. Sheets found: {sheet_names}")
except Exception as e:
    logging.error(f"Failed to load Excel file: {e}")
    exit(1)

# Expected table mappings for regulatory analysis
EXPECTED_TABLES = {
    'rrid_antes_066_24': ['rrid_antes', 'rrid antes', 'antes 066-24'],
    'rrid_despues_066_24': ['rrid_despues', 'rrid despues', 'despues 066-24'],
    'ddv_reg_vs_ddv_ver': ['ddv_reg', 'ddv reg', 'ddv_ver', 'ddv ver', 'ddv-reg', 'ddv-ver'],
    'ddv_verificada': ['ddv_verificada', 'ddv verificada'],
    'msec_reg_vs_msec_desp': ['msec_reg', 'msec reg', 'msec_desp', 'msec desp', 'msec-reg', 'msec-desp', 'mercado secundario'],
    'mapeo_recursos': ['mapeo_recursos', 'mapeo recursos'],
    'mapeo_agentes': ['mapeo_agentes', 'mapeo agentes']
}

# Process each sheet
for sheet_name in sheet_names:
    try:
        logging.info(f"Processing sheet: {sheet_name}")

        # Read the sheet into a DataFrame
        df = pd.read_excel(excel_file, sheet_name=sheet_name)

        # Normalize table name
        table_name = normalize_name(sheet_name)

        # Map to expected regulatory analysis table names
        for expected_name, keywords in EXPECTED_TABLES.items():
            if any(keyword.lower() in sheet_name.lower() for keyword in keywords):
                table_name = expected_name
                break

        # Normalize column names using comprehensive mapping
        df.columns = [column_mapping.get(col, normalize_name(col)) for col in df.columns]

        # Process the table with optimizations
        process_table_data(engine, df, table_name)

    except Exception as e:
        logging.error(f"Error processing sheet '{sheet_name}': {e}")

# Create additional indexes for complex queries
try:
    with engine.connect() as conn:
        # Composite indexes for common joins
        conn.execute(text("CREATE INDEX IF NOT EXISTS idx_ddv_plant_agent_date ON ddv_reg_vs_ddv_ver (planta_nombre, agente_nombre, fecha_dia)"))
        conn.execute(text("CREATE INDEX IF NOT EXISTS idx_ddvv_plant_agent_date ON ddv_verificada (planta_nombre, agente_nombre, fecha_dia)"))
        conn.execute(text("CREATE INDEX IF NOT EXISTS idx_mapeo_sic_agent ON mapeo_recursos (codigo_sic, agente_nombre)"))
        conn.execute(text("CREATE INDEX IF NOT EXISTS idx_mapeo_agentes_sic ON mapeo_agentes (codigo_sic, agente_nombre)"))
        conn.execute(text("CREATE INDEX IF NOT EXISTS idx_rrid_antes_plant ON rrid_antes_066_24 (planta_nombre)"))
        conn.execute(text("CREATE INDEX IF NOT EXISTS idx_rrid_despues_plant ON rrid_despues_066_24 (planta_nombre)"))
        conn.commit()
    logging.info("Additional indexes created for query optimization.")
except Exception as e:
    logging.warning(f"Could not create additional indexes: {e}")

# Generate summary report
def generate_summary_report(engine):
    """Generate a summary report of the imported data."""
    try:
        with engine.connect() as conn:
            logging.info("=== DATABASE SUMMARY REPORT ===")

            for table_name in TABLE_CONFIGS.keys():
                try:
                    result = conn.execute(text(f"SELECT COUNT(*) as count FROM {table_name}"))
                    count = result.fetchone()[0]
                    logging.info(f"{table_name}: {count} records")

                    # Show sample of data
                    sample = conn.execute(text(f"SELECT * FROM {table_name} LIMIT 1")).fetchone()
                    if sample:
                        logging.info(f"  Sample columns: {list(sample.keys())}")

                except Exception as e:
                    logging.warning(f"Could not get info for {table_name}: {e}")

            logging.info("=== REPORT COMPLETE ===")

    except Exception as e:
        logging.warning(f"Could not generate summary report: {e}")

# Generate summary report
generate_summary_report(engine)

logging.info("Regulatory analysis database migration completed successfully.")