--current exhibitions by city
create or replace function current_exhibitions_by_city(city_id_p int)
    returns table
            (
                exhibition_name varchar(200),
                address         varchar(200)
            )
    language sql
as
$$
select e.name, b.place
from exhibitions e
         join exhibition_branch eb on e.id = eb.exhibition_id
         join branches b on eb.branch_id = b.id
where b.city_id = city_id_p
  and ((eb.start_date is null and eb.finish_date is null)
    or (eb.start_date <= now() and eb.finish_date > now()))
$$;



--owners of exhibition parts
create or replace function owners_of_exhibition_parts(exhibition_id_p int)
    returns table
            (
                id    int,
                name  varchar(200),
                email varchar(300),
                phone varchar(20)
            )
    language sql
as
$$
select o.id, o.name, o.contact_email, o.contact_number
from owners o
         join exhibit_owner eo on o.id = eo.owner_id
         join exhibits e on eo.exhibit_id = e.id
         join exhibition_exhibit ee on e.id = ee.exhibit_id
where ee.exhibition_id = exhibition_id_p
$$;

--count exhibits on exhibitions
create or replace function count_exhibits_on_exhibition(exhibition_id_p int)
    returns int
    language sql
as
$$
select count(*)
from exhibition_exhibit
where exhibition_id = exhibition_id_p
$$;

--museum by branch
create or replace function museum_by_branch(branch_id_p int)
    returns table
            (
                id          int,
                name        varchar(200),
                description text
            )
    language sql
as
$$
select m.id, m.name, m.description
from museums m
         join branches b on m.id = b.musem_id
where b.id = branch_id_p
$$;


--branches by museum
create or replace function branches_by_museum(museum_id_p int)
    returns table
            (
                id          int,
                name        varchar(200),
                place       varchar(50),
                description text
            )
    language sql
as
$$
select b.id, b.name, b.place, b.description
from branches b
where b.musem_id = museum_id_p
$$;

--branch by city
create or replace function branch_by_city(city_id_p int)
    returns table
            (
                branch_name varchar(200),
                address     varchar(50)
            )
    language sql
as
$$
select b.name, b.place
from branches b
where b.city_id = city_id_p
$$;


--city of branch
create or replace function city_of_branch(branch_id_p int)
    returns table
            (
                id   int,
                name varchar(200)
            )
    language sql
as
$$
select c.id, c.name
from cities c
         join branches b on c.id = b.city_id
where b.id = branch_id_p
$$;


--branch of exhibition
create or replace function branch_of_exhibition(exhibition_id_p int)
    returns table
            (
                id          int,
                place       varchar(50),
                name        varchar(200),
                description text
            )
    language sql
as
$$
select b.id, b.place, b.name, b.description
from branches b
         join exhibition_branch eb on b.id = eb.branch_id
where eb.exhibition_id = exhibition_id_p
$$;

--exhibits from exhibition
create or replace function exhibits_from_exhibition(exhibition_id_p int)
    returns table
            (
                id          int,
                name        varchar(200),
                type        varchar(50),
                description text,
                date        varchar(50)
            )
    language sql
as
$$
select e.id, e.name, e.type, e.description, e.date
from exhibits e
         join exhibition_exhibit ee on e.id = ee.exhibit_id
where ee.exhibition_id = exhibition_id_p
$$;

--organizers of exhibition
create or replace function organizers_of_exhibition(exhibition_id_p int)
    returns table
            (
                id          int,
                first_name  varchar(100),
                second_name varchar(100),
                post        varchar(200)
            )
    language sql
as
$$
select o.id, o.first_name, o.second_name, eo.post
from organizers o
         join exhibition_organizer eo on o.id = eo.organizer_id
where eo.exhibition_id = exhibition_id_p
$$;


--organizer works
create or replace function organizers_works(organizer_id_p int)
    returns table
            (
                id   int,
                name varchar(200)
            )
    language sql
as
$$
select e.id, e.name
from exhibitions e
         join exhibition_organizer ee on e.id = ee.exhibition_id
where ee.organizer_id = organizer_id_p
$$;



--authors of exhibit
create or replace function authors_of_exhibition(exhibit_id_p int)
    returns table
            (
                id          int,
                first_name  varchar(100),
                second_name varchar(100),
                biography   text,
                country     varchar(70)
            )
    language sql
as
$$
select a.id, a.first_name, a.second_name, a.biography, a.country
from authors a
         join exhibit_author ea on a.id = ea.author_id
where ea.exhibit_id = exhibit_id_p
$$;


--exhibit by author
create or replace function exhibit_by_author(author_id_p int)
    returns table
            (
                id          int,
                name        varchar(200),
                description text,
                type        varchar(50),
                date        varchar(50)
            )
    language sql
as
$$
select e.id, e.name, e.description, e.type, e.date
from exhibits e
         join exhibit_author ea on e.id = ea.exhibit_id
where ea.author_id = author_id_p
$$;

--exhibit by owner
create or replace function exhibit_by_owner(owner_id_p int)
    returns table
            (
                id          int,
                name        varchar(200),
                description text,
                type        varchar(50),
                date        varchar(50)
            )
    language sql
as
$$
select e.id, e.name, e.description, e.type, e.date
from exhibits e
         join exhibit_owner eo on e.id = eo.exhibit_id
where eo.owner_id = owner_id_p
$$;


