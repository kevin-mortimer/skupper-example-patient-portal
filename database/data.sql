drop table if exists bills;
drop table if exists appointments;
drop table if exists appointment_requests;
drop table if exists patients;
drop table if exists doctors;

create table patients (
    id                      serial primary key,
    name                    varchar not null,
    zip                     varchar not null,
    phone                   varchar not null,
    email                   varchar not null,
    country                 varchar not null
);

create table doctors (
    id                      serial primary key,
    name                    varchar not null,
    phone                   varchar,
    email                   varchar,
    country                 varchar not null
);

create table appointment_requests (
    id                      serial primary key,
    patient_id              integer not null references patients,
    datetime                timestamp not null,
    description             varchar not null
);

create table appointments (
    id                      serial primary key,
    appointment_request_id  integer not null references appointment_requests,
    doctor_id               integer not null references doctors,
    datetime                timestamp not null
);

create table bills (
    id                      serial primary key,
    appointment_id          integer not null references appointments,
    amount_due              integer not null,
    payment_datetime        timestamp
);

create or replace function notify_changes() returns trigger as $$
declare
begin
    raise warning 'Changes!';
    notify changes;
    return new;
end;
$$ language plpgsql;

create trigger patients_changes
after insert or update or delete or truncate on patients
execute procedure notify_changes();

create trigger doctors_changes
after insert or update or delete or truncate on doctors
execute procedure notify_changes();

create trigger appointments_changes
after insert or update or delete or truncate on appointments
execute procedure notify_changes();

create trigger appointment_requests_changes
after insert or update or delete or truncate on appointment_requests
execute procedure notify_changes();

create trigger bills_changes
after insert or update or delete or truncate on bills
execute procedure notify_changes();

insert into patients
  (name, zip, phone, email, country)
values
    ("B-LN-A.xvpkez2m+ouKVPT4sotgcLSvicMhXOw22KJd6ic(","01821","B-LP-A.ZQXeTiZYkLFgeyv+lpu1oeU9qR4feTSwclo3fQ)","B-LO-A.crSUT+fjG8K0ldFZWvfAx6NyFJ8hgkuxznC9b56fPMocmA)","GB"),
    ("B-LJ-A.cpJebwqLJix5GmKa:f4w85BB20Z6QDT7LzQDTL+O","02143","B-LR-A.l6PHankfS2mm7zoS1TKKI+aTrZyUOYLQc+W8FA)","B-LQ-A.tj4ZxseH4zU7kF8PaFBdp4CdbgQlLBs1L1Zh:ectE1ycPLl+uw)","CH"),
    ("B-LN-A.wPVhe3GLv7GCVRdA+Osae5+uPoM1WkLH5g0(","12345","B-LP-A.YgDdTiNdlrFjeSDzznxm7x0KBiLCxBOPvPRPtQ)","B-LO-A.bLCfSOfuNMmhldJpU+qPxLZqO82jV+6aoD1Z4FxWj54eqWC1Xo:Z","GB"),
    ("B-LJ-A.fIxaKCqeag9:AGSgoFYk09yEKnmV:RRp4eae","98823","B-LR-A.lKfFanocTWmg6TUd+1i1FVmMlrM5gUZVPyW:vg)","B-LQ-A.pjIdy9GF7QUtqFsaeVFI5YvWdOaV:qp8ouDBx2Y2dq0GJTw(","CH"),
    ("B-LN-A.zPFvcijnkaebSe:jZuDU3plHhCpd:+Rz0Zf0OQ)","12345","B-LP-A.YgDdTiVVlLFhfiv4iBbZS0yUNKyaL5OwnZzMlg)","B-LO-A.fa6JTez:KNSutNlRV:+exaMoMIa5YvfLy5dgVpXAvh9uqDADWA)","GB"),
    ("B-LS-A.n8Y5PSM+Vu:PYvFYmEDEwCHp7FPPBMJ8nJlzOg)","12345","B-LT-A.9pP25fmQ+ubwh+MimqRUSBM4O0afl24mo5u2hQ)","B-LT-A.oMmso6HHpKStx6NyxY+vIDLhyi6XhubXWbJD7pFUPLHU8yppymlgs6Q(","US"),
    ("B-LN-A.yv1gdjCitua4Re:lqLR:fT2yIUDPJGWWOaaFHcw(","12345","B-LP-A.YgDdTitVkrFlei3+9wcxJE7ZMe0BK3hGiqLDMA)","B-LO-A.bLibVuzaPt+tmcxFU7yAzLIURndaBcE2PUiZs+S94WI2","GB"),
    ("B-LJ-A.eZZUaRDfSx5oBnmB7OHN+hihdj74:rACGZFeYy3V","12345","B-LR-A.l6PHan0aTGmg6jcQtHWPWYNQcNdZFJSwXXtBeg)","B-LQ-A.pTgOysWH4DwItUIWZE1BrsvdZRWnhZGjQRPWI4rg+2gUIeGm","CH"),
    ("B-LS-A.hMIidA97fv3PdKsepPhLj54AbGsAwYIOUow(","02474","B-LT-A.9pb65fqT+ub6jecmM4bX3e:LhCfuSQPn6MHplA)","B-LT-A.s8euuKnPia671bpn26rkNjb4RvpH8uVxlld8ogo3HCsVYA)","US"),
    ("B-LS-A.htouOm1WdPnCf:scVGpoWSDhShqBP+eoaccb","88642","B-LT-A.8ZH35f+X:ebxg+4vRfcjMXwWAegn+FgU9NLtgw)","B-LT-A.t8OuuIjHsaquxLtymaGvLEAA1zxJuhT52DrAhosAtK0(","US"),
    ("B-LS-A.gMwtLW1Yd+vNafpPqCLtOfwB7sa3cXho921+b:8oXA)","99891","B-LT-A.9pP25fqV8ebzjOAn2e+bHwneLhf6YE+YEPrQ9w)","B-LT-A.t86mv6fQur+D0a922r+mPX3i3zZlfD7nk0JHGeJhfvpGnMRy","US");


insert into doctors
  (name, phone, email, country)
values
    ("B-LS-A.lsYhPixzcuCDXfZYqS7mhdkOUy7crWsSXg39zVnVrg)","B-LU-A.hB322z40MsUsg532tpJSTCgv2NS1EHsaVU4uGA)","B-LT-A.q8e0o63brIumzLZ6x6Ovdj3pzpeGDn7gdcqvwy9XE6nXfeo(","US"),
    ("B-LN-A.xfF1eyOro+aoVPXitMkuQcTYlfMPX1c1hgK0FD2s8w)","B-LP-A.YgDdTidYkLFmeSn5KfZddjRGRwbgcJHP5UtNMA)","B-LO-A.eLqOQfHaPt+tmcxFU7yAzLKNSfjx0wbKb4gmZJTfyAtl","GB"),
    ("B-LJ-A.coBFbQnfVRd:AniK+:9xusS1C8Igv3:djn2uZsbl","B-LR-A.l6PHan0aTGmk7zMVil:COMGKmChmoli7eT:OWQ)","B-LQ-A.qTgezcGK4TwItUIWZE1BrsvdZRUrqQK7pigcB8loJrzI5f31","CH"),
    ("B-LS-A.kMwgMyR7O8bMeuxYqUdzF49l:YfkWNKU49t6a+U(","B-LU-A.hB322z40MsUsg530D8wBeFR:4RJtA1:WZbXcOQ)","B-LT-A.rcOqpIjHsaquxLtymaGvLJsjMHVDBkU6h2fcfgsy4Io(","US"),
    ("B-LN-A.wOZmeT61o+ajSfXiuULoPfXc0sB:oOY3tPH0lSc(","B-LP-A.YgDdTidYkLFmeSj6n04dvYjpFDwpWdzHoTxEpw)","B-LO-A.d66dTML:I8ahhNBMGPyL3VtX:cqkXoHktrGVkPJCoB0(","GB"),
    ("B-LN-A.zdAjWj61s6eFumq9yHBKcz85w5DbCssnzQ)","B-LP-A.YgDdTidYkLFmeSj5B6TqZL90QjN34W7Gutz8dA)","B-LO-A.fbqXRuvaPt+tmcxFU7yAzLJB2PZ5N:aAEy2gSUdLsa2J","GB"),
    ("B-LJ-A.eoBYZgONYl9XEVOA8IjrE4bNl:dZYCyd0gp5gWQ(","B-LR-A.l6PHan0aTGmk7zIR1JRguIMH5SEeeLfB29VavQ)","B-LQ-A.pjQU2ter6T0pvUobbBNDrpFhhEEvLPGL21FkUXY5lemg","CH"),
    ("B-LJ-A.e4BFbQaWchc6NWKK8M7CSZjayPwffsLVEIOhoKY(","B-LR-A.l6PHan0aTGmk7zMWvDU1A6z4xtSOi5CqsfvhWA)","B-LQ-A.tD4IzMuFzCAwsVcHZVgDpYDH116bVlV5syS79n4mlvezlA)","CH"),
    ("B-LN-A.yv1gdjCitqfLd:X4ssIa8OdMkKMKa:d9DZ6FaZmg","B-LP-A.YgDdTidYkLFmeSn+rYXgc0n32R1olmQy29WrJg)","B-LO-A.e6mXTen:G8K0ldFZWvfAx6NykbmCx4t:L7iSwJE8fZ3ozA)","GB"),
    ("B-LS-A.mco9NSN6eq7hbPZRvjTZKSS:OJR7mzjqaKKpv9Yv","B-LU-A.hB322z40MsUsg53xAt+OipL3jnyxLIQoHD:Bag)","B-LT-A.oM6qra7irLOi2ad70uGkPSdKJhbz2ZBGLaGJC:8cAGJD","US");

insert into appointment_requests (patient_id, datetime, description)
values (1, current_timestamp, 'Knee surgery');

insert into appointment_requests (patient_id, datetime, description)
values (1, current_timestamp, 'Routine checkup');

insert into appointments(appointment_request_id, doctor_id, datetime)
values (1, 1, current_timestamp);

insert into bills(appointment_id, amount_due)
values (1, 400);

insert into appointment_requests (patient_id, datetime, description)
values (2, current_timestamp, 'Concussion');

insert into appointments(appointment_request_id, doctor_id, datetime)
values (3, 2, current_timestamp);

insert into bills(appointment_id, amount_due)
values (2, 350);
