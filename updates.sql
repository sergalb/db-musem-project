--variables for language sql doesn't support variable using in postgres, so i use plpgsql


--read committed transaction level because of pk is single real-world constraint for this procedure
--add_organizer
create or replace procedure add_organizer(in first_name_p varchar(100), second_name_p varchar(100))
    language plpgsql
as
$$
declare
    organizer_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into organizer_id_v from organizers;
    insert into organizers (id, first_name, second_name)
    values (organizer_id_v, first_name_p, second_name_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_author
create or replace procedure add_author(in first_name_p varchar(100), second_name_p varchar(100),
                                       in country_p varchar(70) default null, in biography_p text default null)
    language plpgsql
as
$$
declare
    author_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into author_id_v from authors;
    insert into authors (id, first_name, second_name, country, biography)
    values (author_id_v, first_name_p, second_name_p, country_p, biography_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_owner
create or replace procedure add_owner(in name_p varchar(200), contact_number_p varchar(20) default null,
                                      in contact_email_p varchar(300) default null)
    language plpgsql
as
$$
declare
    owner_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into owner_id_v from owners;
    insert into owners (id, name, contact_number, contact_email)
    values (owner_id_v, name_p, contact_number_p, contact_email_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_exhibit
create or replace procedure add_exhibit(in name_p varchar(200), in type_p varchar(50),
                                        in description_p text default null,
                                        in date_p varchar(50) default null)
    language plpgsql
as
$$
declare
    exhibit_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into exhibit_id_v from exhibits;
    insert into exhibits (id, name, description, type, date)
    values (exhibit_id_v, name_p, description_p, type_p, date_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_exhibition
create or replace procedure add_exhibition(in name_p varchar(200))
    language plpgsql
as
$$
declare
    exhibition_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into exhibition_id_v from exhibitions;
    insert into exhibitions (id, name)
    values (exhibition_id_v, name_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_branch
create or replace procedure add_branch(in name_p varchar(200), in place_p varchar(200),
                                       in description_p text default null,
                                       in museum_id_p int default null, city_id_p int default null)
    language plpgsql
as
$$
declare
    branch_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into branch_id_v from branches;
    insert into branches (id, place, name, description, musem_id, city_id)
    values (branch_id_v, place_p, name_p, description_p, museum_id_p, city_id_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_museum
create or replace procedure add_museum(in name_p varchar(200), in description_p text default null)
    language plpgsql
as
$$
declare
    museum_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into museum_id_v from museums;
    insert into museums (id, name, description)
    values (museum_id_v, name_p, description_p);
end;
$$;

--read committed transaction level because of pk is single real-world constraint for this procedure
--add_city
create or replace procedure add_city(in name_p varchar(200))
    language plpgsql
as
$$
declare
    city_id_v int;
begin
    -- default sql syntax doesn't supports
    select coalesce(max(id), 0) + 1 into city_id_v from cities;
    insert into cities (id, name)
    values (city_id_v, name_p);
end;
$$;


--read committed transaction level because of elements of both table never removed.
--We can check that fk exist any time, it mean this fk will exist in the future.
--add_exhibit_owner
create or replace procedure add_exhibit_owner(in exhibit_id_p int, owner_id_p int)
    language plpgsql
as
$$
begin
    insert into exhibit_owner (exhibit_id, owner_id)
    values (exhibit_id_p, owner_id_p);
end;
$$;

--read committed transaction level because of elements of both table never removed.
--We can check that fk exist any time, it mean this fk will exist in the future.
--add_exhibit_author
create or replace procedure add_exhibit_author(in exhibit_id_p int, author_id_p int)
    language plpgsql
as
$$
begin
    insert into exhibit_author (exhibit_id, author_id)
    values (exhibit_id_p, author_id_p);
end;
$$;

--read repeat transaction level because of this procedure require existing id's in theirs main tables
--add_exhibit_to_exhibition
create or replace procedure add_exhibit_to_exhibition(in exhibit_id_p int, exhibition_id_p int)
    language plpgsql
as
$$
begin
    execute check_exhibition_exist(exhibition_id_p);
    insert into exhibition_exhibit (exhibit_id, exhibition_id)
    values (exhibit_id_p, exhibition_id_p);
end;
$$;


--read repeat transaction level because of this procedure require existing id's in theirs main tables
--add_organizer_to_exhibition
create or replace procedure add_organizer_to_exhibition(in organizer_id_p int, exhibition_id_p int, in post_p varchar(200))
    language plpgsql
as
$$
begin
    execute check_exhibition_exist(exhibition_id_p);
    insert into exhibition_organizer (organizer_id, exhibition_id, post)
    values (organizer_id_p, exhibition_id_p, post_p);
end;
$$;



--read repeat transaction level because of required exhibition may be removed during transaction
--add_exhibition_to_branch
create or replace procedure add_exhibition_to_branch(in branch_id_p int, exhibition_id_p int,
                                                     in start_date_p date default null,
                                                     in finish_date_p date default null)
    language plpgsql
as
$$
begin
    execute check_exhibition_exist(exhibition_id_p);
    execute check_date(start_date_p, finish_date_p);
    insert into exhibition_branch (branch_id, exhibition_id, start_date, finish_date)
    values (branch_id_p, exhibition_id_p, start_date_p, finish_date_p);
end;
$$;

--read repeat transaction level because of required exhibition may be removed during transaction
--update_post
create or replace procedure update_post(in organizer_id_p int, in exhibition_id_p int, new_post varchar(200))
    language plpgsql
as
$$
begin
    execute check_exhibition_exist(exhibition_id_p);
    update exhibition_organizer eo
    set post = new_post
    where eo.organizer_id = organizer_id_p
      and eo.exhibition_id = exhibition_id_p;
end;
$$;

--read repeat transaction level because of required exhibition may be removed during transaction
--update_exhibition_date
create or replace procedure update_exhibition_date(in branch_id_p int, in exhibition_id_p int, start_date_p date,
                                                   finish_date_p date)
    language plpgsql
as
$$
begin
    execute check_exhibition_exist(exhibition_id_p);
    execute check_date(start_date_p, finish_date_p);
    update exhibition_branch eb
    set start_date  = start_date_p,
        finish_date = finish_date_p
    where eb.branch_id = branch_id_p
      and eb.exhibition_id = exhibition_id_p;
end;
$$;

--read commit transaction level because of removing
--remove_temporary_exhibition
create or replace procedure remove_temporary_exhibition(in exhibition_id_p int)
    language plpgsql
as
$$
declare
    start_date_v  int;
    finish_date_v int;
begin
    select start_date, finish_date
    into start_date_v, finish_date_v
    from exhibition_branch
    where exhibition_id = exhibition_id_p;
    if start_date_v is not null and finish_date_v is not null
    then
        rollback;
    end if;
    delete from exhibitions where exhibition_id_p = exhibitions.id;
end;
$$;

--during normal operation, data from other tables should not be removed

--check_exhibition_exist
create or replace procedure check_exhibition_exist(in exhibition_id_p int)
    language plpgsql
as
$$
begin
    if not exists(select * from exhibitions where exhibitions.id = exhibition_id_p)
    then
        rollback;
    end if;
end ;
$$;

--check_exhibition_exist
create or replace procedure check_date(in start_date date, in finish_date date)
    language plpgsql
as
$$
begin
    if (start_date is null != finish_date is null) or
       (start_date is not null and finish_date is not null and start_date > finish_date)
    then
        rollback;
    end if;
end ;
$$;
