--current exhibitions
select e.name, b.place
from exhibitions e
         join exhibition_branch on e.id = exhibition_branch.exhibition_id
         join branches b on exhibition_branch.branch_id = b.id
where (e.start_date is null and e.finish_date is null)
   or (e.start_date <= now() and e.finish_date > now());


--exhibits from exhibition
create or replace function exhibits_from_exhibition(exhibition_id_p int)
    returns table
            (
                id          int,
                name        varchar,
                type        varchar,
                description varchar,
                date        varchar
            )
    language sql
as
$$
select e.id, e.name, e.type, e.description, e.date
from exhibits e
         join exhibition_exhibit ee on e.id = ee.exhibit_id
where ee.exhibition_id = exhibition_id_p
$$;

--owners of exhibition parts
create or replace function owners_of_exhibition_parts(exhibition_id_p int)
    returns table
            (
                id    int,
                name  varchar(200),
                email varchar(200),
                phone varchar(200)
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

--branches by museum
create or replace function branches_by_museum(museum_id_p int)
    returns table
            (
                id          int,
                name        varchar,
                place       varchar,
                description varchar
            )
    language sql
as
$$
select b.id, b.name, b.place, b.description
from branches b
where b.musem_id = museum_id_p
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

$$