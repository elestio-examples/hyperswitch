#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 150s;

docker-compose up -d migration_runner
docker-compose up -d opensearch
sleep 150s;