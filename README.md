# vagrant_template


 `vagrant up`


rebuild: `vagrant destroy -f && vagrant up`
 
Export: `vagrant package --output mynew.box`

 
Login to postgres
 psql -U postgres

create user dev_user with password 'password';
alter role dev_user superuser createrole createdb replication;
create database development owner dev_user;