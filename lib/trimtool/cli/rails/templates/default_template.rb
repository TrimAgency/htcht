#
# App Setup
# ----------------------------

# Edit database.yml to work with docker
insert_into_file('config/database.yml', "\s\susername: postgres\n\s\spassword:\n\s\shost: postgres\n\s\sport: 5432\n", :after => "default: &default\n")
