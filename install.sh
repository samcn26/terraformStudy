until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1;
done

apt-get update
apt-get install -y nginx openjdk-8.0-jdk