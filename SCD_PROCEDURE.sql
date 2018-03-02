BEGIN
insert into scdtab1 t1
    select
        tt2.COL1,
        tt2.COL2,
        (select to_char(sysdate, 'YYYY-MM-DD') from dual),
        '9999-01-01 00:00:00',
        tt2.ID,
        0
    from SCDTAB2 tt2
    join SCDTAB1 tt1
        on tt1.ID=tt2.ID
    where
        tt1.CURRENT_STATE_FLAG = 1
        and (tt1.COL1 != tt2.COL1 or tt1.COL2 != tt2.COL2);

update scdtab1 t1
    set
        t1.date_to = (select to_char(sysdate, 'YYYY-MM-DD') from dual)
        ,t1.current_state_flag = 0
    where id = (
        select
            distinct tt1.ID
        from SCDTAB2 tt2
        join SCDTAB1 tt1
            on tt1.ID=tt2.ID
        where
            tt1.CURRENT_STATE_FLAG = 1
            and(tt1.COL1 != tt2.COL1
            or tt1.COL2 != tt2.COL2)
    )
    and t1.CURRENT_STATE_FLAG = 1;
    
update SCDTAB1 t1 set t1.CURRENT_STATE_FLAG = 1 where t1.DATE_TO='9999-01-01 00:00:00';

insert into scdtab1 t1
    select
        tt2.COL1,
        tt2.COL2,
        (select to_char(sysdate, 'YYYY-MM-DD') from dual),
        '9999-01-01 00:00:00',
        tt2.ID,
        1
    from SCDTAB2 tt2
    left join SCDTAB1 tt1
        on tt1.ID=tt2.ID
    where
        tt1.ID is null;
END;