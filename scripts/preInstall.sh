#set env vars
set -o allexport; source .env; set +o allexport;


git clone https://github.com/juspay/hyperswitch.git hyper

mkdir -p ./migrations/migrations
mkdir -p ./config
mkdir -p ./monitoring
chown -R 1000:1000 ./migrations

cp -r ./hyper/migrations/* ./migrations/migrations
cp -r ./hyper/config/docker_compose.toml ./config/docker_compose.toml
cp -r ./hyper/config/redis.conf ./config/redis.conf
cp -r ./hyper/config/grafana.ini ./config/grafana.ini
cp -r ./hyper/config/grafana-datasource.yaml ./config/grafana-datasource.yaml
cp -r ./hyper/config/promtail.yaml ./config/promtail.yaml
cp -r ./hyper/config/loki.yaml ./config/loki.yaml
cp -r ./hyper/config/otel-collector.yaml ./config/otel-collector.yaml
cp -r ./hyper/config/prometheus.yaml ./config/prometheus.yaml
cp -r ./hyper/config/tempo.yaml ./config/tempo.yaml
cp -r ./hyper/monitoring/kafka-script.sh ./monitoring/kafka-script.sh

chmod +x ./monitoring/kafka-script.sh

sed -i "s~db_user~${POSTGRES_USER}~g" ./config/docker_compose.toml
sed -i "s~db_pass~${POSTGRES_PASSWORD}~g" ./config/docker_compose.toml
sed -i "s~test_admin~${ADMIN_PASSWORD}~g" ./config/docker_compose.toml
sed -i "s~jwt_secret = \"secret\"~jwt_secret = \"${ADMIN_PASSWORD}\"~g" ./config/docker_compose.toml
sed -i "s~recon_test_admin~${ADMIN_PASSWORD}~g" ./config/docker_compose.toml
sed -i "s~\${HOSTNAME}~${DOMAIN}~g" ./config/grafana.ini
sed -i "s~domain = localhost~domain = ${DOMAIN}~g" ./config/grafana.ini
sed -i "s~host = localhost:25~host = 172.17.0.1:25~g" ./config/grafana.ini
sed -i "s~from_address = admin@grafana.localhost~from_address = ${FROM_EMAIL}~g" ./config/grafana.ini

rm -rf ./hyper