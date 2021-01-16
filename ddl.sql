create table museums
(
    id          int          not null,
    name        varchar(200) not null,
    description text,
    constraint museum_pk primary key (id)
);

create table cities
(
    id   int          not null,
    name varchar(200) not null,
    constraint city_pk primary key(id)
);

create table branches
(
    id          int          not null,
    place       varchar(200) not null,
    name        varchar(200) not null,
    description text,
    musem_id    int          not null,
    city_id    int          not null,
    constraint branch_pk primary key (id),
    constraint branch_museum_fk foreign key (musem_id) references museums (id),
    constraint branch_city_fk foreign key (city_id) references cities (id)
);


create table exhibitions
(
    id          int          not null,
    name        varchar(200) not null,
    start_date  date,
    finish_date date,
    constraint exhibition_pk primary key (id)
);

create table organizers
(
    id          int          not null,
    first_name  varchar(200) not null,
    second_name varchar(200) not null,
    constraint organizer_pk primary key (id)
);

create table exhibits
(
    id          int          not null,
    name        varchar(200) not null,
    description text,
    type        varchar(50)  not null,
    date        varchar(50),
    constraint exhibit_pk primary key (id)
);

create table authors
(
    id          int          not null,
    first_name  varchar(200) not null,
    second_name varchar(200) not null,
    biography   text,
    country     varchar(70),
    constraint authors_pk primary key (id)
);

create table owners
(
    id             int not null,
    name           varchar(200),
    contact_number varchar(20),
    contact_email  varchar(300),
    constraint owner_pk primary key (id)
);

create table exhibition_branch
(
    branch_id     int not null,
    exhibition_id int not null,
    constraint exhibition_branch_pk primary key (branch_id, exhibition_id),
    constraint exhibition_branch_exhibition_fk foreign key (exhibition_id) references exhibitions (id),
    constraint exhibition_branch_branch_fk foreign key (branch_id) references branches (id)
);

create table exhibition_organizer
(
    exhibition_id int          not null,
    organizer_id  int          not null,
    post          varchar(200) not null,
    constraint exhibition_organizer_pk primary key (organizer_id, exhibition_id),
    constraint exhibition_organizer_exhibition_fk foreign key (exhibition_id) references exhibitions (id),
    constraint exhibition_organizer_organizer_fk foreign key (organizer_id) references organizers (id)
);

create table exhibit_author
(
    exhibit_id int not null,
    author_id  int not null,
    constraint exhibit_author_pk primary key (exhibit_id, author_id),
    constraint exhibit_author_exhibit_fk foreign key (exhibit_id) references exhibits (id),
    constraint exhibit_author_author_fk foreign key (author_id) references authors (id)
);



create table exhibit_owner
(
    exhibit_id int not null,
    owner_id   int not null,
    constraint exhibit_owner_pk primary key (exhibit_id),
    constraint exhibit_owner_exhibit_fk foreign key (exhibit_id) references exhibits (id),
    constraint exhibit_owner_owner_fk foreign key (owner_id) references owners (id)
);

create table exhibition_exhibit
(
    exhibit_id    int not null,
    exhibition_id int not null,
    constraint exhibit_exhibit_pk primary key (exhibition_id, exhibit_id),
    constraint exhibit_exhibit_exhibit_fk foreign key (exhibit_id) references exhibits (id),
    constraint exhibit_exhibit_exhibition_fk foreign key (exhibition_id) references exhibitions (id)
);