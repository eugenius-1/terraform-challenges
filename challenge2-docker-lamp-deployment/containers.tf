resource "docker_container" "php-httpd" {
  name     = "webserver"
  image    = docker_image.php-httpd-image.name
  hostname = "php-httpd"
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
  labels {
    label = "challenge"
    value = "second"
  }
  volumes {
    host_path      = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
    container_path = "/var/www/html"
  }
}

resource "docker_container" "phpmyadmin" {
  name     = "db_dashboard"
  image    = docker_image.phpmyadmin-image.name
  hostname = "phpmyadmin"
  ports {
    internal = 80
    external = 8081
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
  links = [ "${docker_container.mariadb.name}:db" ]  # Deprecated but used to fulfill challenge requirements
  labels {
    label = "challenge"
    value = "second"
  }
  depends_on = [docker_container.mariadb]
}

resource "docker_container" "mariadb" {
  name     = "db"
  image    = docker_image.mariadb-image.name
  hostname = "db"
  env = [
    "MYSQL_ROOT_PASSWORD=1234",
    "MYSQL_DATABASE=simple-website"
  ]
  ports {
    internal = 3306
    external = 3306
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
  labels {
    label = "challenge"
    value = "second"
  }
  volumes {
    volume_name    = docker_volume.mariadb_volume.name
    container_path = "/var/lib/mysql"
  }
}