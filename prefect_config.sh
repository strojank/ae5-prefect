# Credential from Anaconda Enterprise vault
azure_credential=$(cat /var/run/secrets/user_credentials/azure_connect_str)

# Create .prefect
if [ -d "/opt/continuum/.prefect" ] 
then
    echo "Directory /opt/continuum/.prefect." 
else
    mkdir /opt/continuum/.prefect
fi

# Create config.toml inside .prefect
if [ -w "opt/continuum/.prefect/config.toml" ]
then
    echo "use_local_secrets = true" >> /opt/continuum/.prefect/config.toml
    echo "[context.secrets]" >> /opt/continuum/.prefect/config.toml
    echo "azure_credential = '$azure_credential'" >> /opt/continuum/.prefect/config.toml
else
    touch /opt/continuum/.prefect/config.toml
    echo "[cloud]" > /opt/continuum/.prefect/config.toml
    echo "use_local_secrets = true" >> /opt/continuum/.prefect/config.toml
    echo "[context.secrets]" >> /opt/continuum/.prefect/config.toml
    echo "azure_credential = '$azure_credential'" >> /opt/continuum/.prefect/config.toml
fi