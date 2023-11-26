create table nearby_locations
(
    id      int identity primary key,
    name_vn nvarchar(255),
    name_kr nvarchar(255),
)
insert into nearby_locations(name_vn, name_kr) values (N'S�n bay', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Nh� h�ng', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Qu�n nh?u', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Bi?n', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'N�i', N'?')
insert into nearby_locations(name_vn, name_kr) values (N'Si�u th?', N'????')
insert into nearby_locations(name_vn, name_kr) values (N'Trung t�m mua s?m', N'?? ??')
insert into nearby_locations(name_vn, name_kr) values (N'C�ng vi�n', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Ng�n h�ng', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'ATM', N'ATM')
insert into nearby_locations(name_vn, name_kr) values (N'Ch? ?�m', N'???')
insert into nearby_locations(name_vn, name_kr) values (N'Qu�n c� ph�', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Qu�n bar', N'??')
create table property_types
(
    id             int identity primary key,
    name_vn        nvarchar(255),
    name_kr        nvarchar(255),
    description_vn nvarchar(2550),
    description_kr nvarchar(2550)
)
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Chung C?', N'???', N'C?n h? ?a d?ng v?i nhi?u lo?i di?n t�ch, th�ch h?p cho c� nh�n ho?c gia ?�nh nh?, th??ng c� c�c ti?n �ch chung.', N'???? ???? ??? ???? ??? ??? ??? ???? ???? ???, ?? ????? ?? ??? ????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Nh� Ri�ng', N'?', N'Ng�i nh� ??c l?p, cung c?p kh�ng gian ri�ng t? v?i s�n v??n, th�ch h?p cho gia ?�nh l?n ho?c ng??i mu?n kh�ng gian ri�ng t?.', N'??? ?? ?? ??? ???? ??? ???? ????? ?? ??? ??? ????? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Bi?t Th?', N'??', N'Ng�i nh� cao c?p v?i kh�ng gian l?n, ti?n �ch sang tr?ng, th??ng n?m trong khu ?� th? ho?c ven bi?n.', N'?? ??? ????? ?? ??? ?? ?? ???? ?? ??? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n H? Studio', N'???? ???', N'C?n h? nh? g?n v?i kh�ng gian m?, k?t h?p gi?a ph�ng ng?, ph�ng kh�ch v� nh� b?p trong m?t kh�ng gian duy nh?t.', N'??, ??, ??? ??? ??? ??? ??? ??? ?? ?? ??????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n h? loft', N'??? ???', N'Ng�i nh� c� tr?n cao, th??ng ???c chuy?n ??i t? c�c kh�ng gian c�ng nghi?p, mang ??n kh�ng gian s?ng ??c ?�o.', N'??? ?? ?? ??? ??? ?? ??? ?? ??? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'nh� ph? th??ng m?i', N'??? ?????', N'Ng�i nh� k?t h?p gi?a kh�ng gian ? v� kh�ng gian kinh doanh, th??ng n?m trong khu v?c th??ng m?i.', N'?? ?? ??? ???? ??? ???? ?? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n H? D?ch V?', N'??? ???', N'C?n h? ?� ???c trang b? ??y ?? n?i th?t v� d?ch v?, th�ch h?p cho ng??i ?ang t?m tr� ho?c ?i c�ng t�c.', N'????? ??? ???? ???? ?? ????? ????? ??? ?? ????? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Nh� Ph?', N'?????', N'Ng�i nh� ???c x�y d?ng li?n k? nhau, th??ng c� nhi?u t?ng, mang l?i s? thu?n ti?n v� kh�ng gian s?ng c?ng ??ng.', N'??? ?? ?? ???? ?? ??? ?? ???? ???? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n H? Cao C?p', N'??? ???', N'C?n h? cao c?p v?i n?i th?t v� ti?n �ch sang tr?ng, th�ch h?p cho ng??i mu?n tr?i nghi?m cu?c s?ng ??ng c?p.', N'????? ??? ?? ??? ?? ??? ???? ?? ?? ?? ???? ?? ????? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Bi?t Th? Ngh? D??ng', N'??', N'Bi?t th? n?m trong khu ngh? d??ng, mang l?i kh�ng gian y�n b�nh v� ti?n �ch gi?i tr�, th�ch h?p cho k? ngh? v� ngh? cu?i tu?n.', N'??? ??? ?? ???? ?? ?? ? ??? ??? ???? ??? ?????? ??? ?????.')
create table provinces
(
    id   int identity primary key,
    name nvarchar(255)
)
insert into provinces(name) values (N'?� N?ng')
insert into provinces(name) values (N'Qu?ng Nam')
insert into provinces(name) values (N'Hu?')
insert into provinces(name) values (N'H� N?i')
insert into provinces(name) values (N'Th�nh ph? H? Ch� Minh')
insert into provinces(name) values (N'H?i Ph�ng')
create table districts
(
    id          int identity primary key,
    name        nvarchar(255),
    province_id int references provinces
)
insert into districts(name, province_id) values (N'Li�n Chi?u', 1)
insert into districts(name, province_id) values (N'Thanh Kh�', 1)
insert into districts(name, province_id) values (N'H?i Ch�u', 1)
insert into districts(name, province_id) values (N'S?n Tr�', 1)
insert into districts(name, province_id) values (N'Ng? H�nh S?n', 1)
insert into districts(name, province_id) values (N'C?m L?', 1)
insert into districts(name, province_id) values (N'H�a Vang', 1)
insert into districts(name, province_id) values (N'Ho�ng Sa', 1)

insert into districts(name, province_id) values (N'B?c Tr� My', 2)
insert into districts(name, province_id) values (N'Duy Xuy�n', 2)
insert into districts(name, province_id) values (N'??i L?c', 2)
insert into districts(name, province_id) values (N'?�ng Giang', 2)
insert into districts(name, province_id) values (N'?i?n B�n', 2)
insert into districts(name, province_id) values (N'Hi?p ??c', 2)
insert into districts(name, province_id) values (N'Nam Giang', 2)
insert into districts(name, province_id) values (N'Nam Tr� My', 2)
insert into districts(name, province_id) values (N'Ph� Ninh', 2)
insert into districts(name, province_id) values (N'N�i Th�nh', 2)
insert into districts(name, province_id) values (N'Ph??c S?n', 2)
insert into districts(name, province_id) values (N'Qu? S?n', 2)
insert into districts(name, province_id) values (N'T�y Giang', 2)
insert into districts(name, province_id) values (N'Ti�n Ph??c', 2)
insert into districts(name, province_id) values (N'Th?ng B�nh', 2)
insert into districts(name, province_id) values (N'th? x� H?i An', 2)
insert into districts(name, province_id) values (N'th�nh ph? Tam K?', 2)

insert into districts(name, province_id) values (N'Phong ?i?n', 3)
insert into districts(name, province_id) values (N'Qu?ng ?i?n', 3)
insert into districts(name, province_id) values (N'Ph� L?c', 3)
insert into districts(name, province_id) values (N'Nam ?�ng', 3)
insert into districts(name, province_id) values (N'A L??i', 3)
insert into districts(name, province_id) values (N'Ph� Vang', 3)
insert into districts(name, province_id) values (N'H??ng Tr�', 3)
insert into districts(name, province_id) values (N'H??ng Th?y', 3)

insert into districts(name, province_id) values (N'Ho�n Ki?m', 4)
insert into districts(name, province_id) values (N'??ng ?a', 4)
insert into districts(name, province_id) values (N'Ba ?�nh', 4)
insert into districts(name, province_id) values (N'Hai B� Tr?ng', 4)
insert into districts(name, province_id) values (N'Ho�ng Mai', 4)
insert into districts(name, province_id) values (N'Thanh Xu�n', 4)
insert into districts(name, province_id) values (N'Long Bi�n', 4)
insert into districts(name, province_id) values (N'Nam T? Li�m', 4)
insert into districts(name, province_id) values (N'B?c T? Li�m', 4)
insert into districts(name, province_id) values (N'T�y H?', 4)
insert into districts(name, province_id) values (N'C?u Gi?y', 4)
insert into districts(name, province_id) values (N'H� ?�ng', 4)
insert into districts(name, province_id) values (N'Ba V�', 4)
insert into districts(name, province_id) values (N'Ch??ng M?', 4)
insert into districts(name, province_id) values (N'Ph�c Th?', 4)
insert into districts(name, province_id) values (N'?an Ph??ng', 4)
insert into districts(name, province_id) values (N' ?�ng Anh', 4)
insert into districts(name, province_id) values (N'Gia L�m', 4)
insert into districts(name, province_id) values (N'Ho�i ??c', 4)
insert into districts(name, province_id) values (N'M� Linh', 4)
insert into districts(name, province_id) values (N'M? ??c', 4)
insert into districts(name, province_id) values (N'Ph� Xuy�n', 4)
insert into districts(name, province_id) values (N'Qu?c Oai', 4)
insert into districts(name, province_id) values (N'S�c S?n', 4)
insert into districts(name, province_id) values (N'Th?ch Th?t', 4)
insert into districts(name, province_id) values (N'Thanh Oai', 4)
insert into districts(name, province_id) values (N'Th??ng T�n', 4)
insert into districts(name, province_id) values (N'?ng H�a', 4)
insert into districts(name, province_id) values (N'Thanh Tr�', 4)
insert into districts(name, province_id) values (N'S?n T�y', 4)


insert into districts(name, province_id) values (N'Qu?n 1', 5)
insert into districts(name, province_id) values (N'Qu?n 3', 5)
insert into districts(name, province_id) values (N'Qu?n 4', 5)
insert into districts(name, province_id) values (N'Qu?n 5', 5)
insert into districts(name, province_id) values (N'Qu?n 6', 5)
insert into districts(name, province_id) values (N'Qu?n 7', 5)
insert into districts(name, province_id) values (N'Qu?n 8', 5)
insert into districts(name, province_id) values (N'Qu?n 10', 5)
insert into districts(name, province_id) values (N'Qu?n 11', 5)
insert into districts(name, province_id) values (N'T�n Ph�', 5)
insert into districts(name, province_id) values (N'T�n B�nh', 5)
insert into districts(name, province_id) values (N'G� V?p', 5)
insert into districts(name, province_id) values (N'Ph� Nhu?n', 5)
insert into districts(name, province_id) values (N'B�nh Th?nh', 5)
insert into districts(name, province_id) values (N'Th? ??c', 5)
insert into districts(name, province_id) values (N'Nh� B�', 5)
insert into districts(name, province_id) values (N'B�nh Ch�nh', 5)
insert into districts(name, province_id) values (N'C?n Gi?', 5)


insert into districts(name, province_id) values (N'H?ng B�ng', 6)
insert into districts(name, province_id) values (N'L� Ch�n', 6)
insert into districts(name, province_id) values (N'Ng� Quy?n', 6)
insert into districts(name, province_id) values (N'An D??ng', 6)
insert into districts(name, province_id) values (N'An L�o', 6)
insert into districts(name, province_id) values (N'C�t B�', 6)
insert into districts(name, province_id) values (N'C�t H?i', 6)
insert into districts(name, province_id) values (N'H?i An', 6)
insert into districts(name, province_id) values (N'Ki?n Th?y', 6)
insert into districts(name, province_id) values (N'Th?y Nguy�n', 6)
insert into districts(name, province_id) values (N'Ti�n L�ng', 6)
insert into districts(name, province_id) values (N'V?nh B?o', 6)



create table users
(
    id             int identity primary key,
    name           nvarchar(255) not null,
    email          nvarchar(255) not null,
    password       nvarchar(255),
    avatar         nvarchar(255) not null,
    phone          nvarchar(255),
    dob            date,
    nationality    nvarchar(255),
    national_id    nvarchar(255),
    front_id_card  nvarchar(255),
    back_id_card   nvarchar(255),
    hash           nvarchar(255),
    is_verified    bit not null,
    cards_verified bit not null,
    is_admin       bit not null,
)
INSERT INTO korean.dbo.users (name, email, password, avatar, phone, dob, nationality, national_id, front_id_card, back_id_card, hash, is_verified, cards_verified, is_admin) VALUES (N'Admin', N'admin@gmail.com', N'admin123', N'/files/default-avatar.webp', N'0123456789', N'2002-08-05', N'Viet Nam', N'048202001288', null, null, null, 1, 0, 1);
INSERT INTO korean.dbo.users (name, email, password, avatar, phone, dob, nationality, national_id, front_id_card, back_id_card, hash, is_verified, cards_verified, is_admin) VALUES (N'Quang Minh Tr?n', N'tranquangminh116@gmail.com', N'050820021', N'https://lh3.googleusercontent.com/a/ACg8ocIt8XtJpqw1ntOyeAJF8XyacXD7_UdomYCc7OyZ4mN5vg=s96-c', N'0123456789', N'2002-08-05', N'Viet Nam', N'048202001288', null, null, null, 1, 0, 0);
create table amenities
(
    id      int identity primary key,
    name_vn nvarchar(255),
    name_kr nvarchar(255),
)
insert into amenities(name_vn, name_kr) values (N'Free Wifi', N'?? ????')
insert into amenities(name_vn, name_kr) values (N'?i?u h�a n�ng l?nh', N'???/??')
insert into amenities(name_vn, name_kr) values (N'B?a s�ng mi?n ph�', N'?? ?? ??')
insert into amenities(name_vn, name_kr) values (N'Qu?y l? t�n 24 gi?', N'24?? ??? ???')
insert into amenities(name_vn, name_kr) values (N'D?ch v? ph�ng', N'? ???')
insert into amenities(name_vn, name_kr) values (N'B�i ??u xe', N'???')
insert into amenities(name_vn, name_kr) values (N'??a ?�n s�n bay', N'?? ??')
insert into amenities(name_vn, name_kr) values (N'Trung t�m th? d?c', N'???? ??')
insert into amenities(name_vn, name_kr) values (N'H? b?i', N'???')
insert into amenities(name_vn, name_kr) values (N'D?ch v? v?n ph�ng', N'???? ??')
insert into amenities(name_vn, name_kr) values (N'D?ch v? h??ng d?n kh�ch', N'???? ???')
insert into amenities(name_vn, name_kr) values (N'Cho ph�p th� c?ng', N'?? ?? ?? ??')
insert into amenities(name_vn, name_kr) values (N'Trung t�m Spa/ch?m s�c s?c kh?e', N'??/???? ??')
insert into amenities(name_vn, name_kr) values (N'Khu v?c Lounge/Bar', N'???/? ??')
insert into amenities(name_vn, name_kr) values (N'D?ch v? gi?t l�', N'?? ???')
insert into amenities(name_vn, name_kr) values (N'Kh�ng gian h?i h?p/s? ki?n', N'??/??? ??')
insert into amenities(name_vn, name_kr) values (N'Khu vui ch?i tr? em', N'??? ?? ??')
insert into amenities(name_vn, name_kr) values (N'K�t an to�n', N'??? ??')
insert into amenities(name_vn, name_kr) values (N'Ph�ng d�nh cho ng??i khuy?t t?t', N'???? ?? ??')
insert into amenities(name_vn, name_kr) values (N'T�y ch?n gi?i tr�', N'?????? ??')
create table properties
(
    id             int identity primary key,
    name_vn        nvarchar(500),
    name_kr        nvarchar(500),
    property_type  int references property_types,
    description_vn nvarchar( max),
    description_kr nvarchar( max),
    price          float,
    floor_numbers  int,
    at_floor       int,
    district_id    int references districts,
    address        nvarchar(500),
    bedrooms       int,
    bathrooms      int,
    area           int,
    user_id        int references users,
    hidden         bit,
    for_sale       bit,
    sold           bit,
    created_at     datetime
)
create table property_amenities
(
    id          int identity primary key,
    property_id int foreign key references properties,
    amenity_id  int foreign key references amenities
)
create table property_images
(
    id            int identity primary key,
    property_id   int references properties,
    path          nvarchar(500),
    is_thumb_nail bit
)
create table property_near_location
(
    id               int identity primary key,
    property_id      int foreign key references properties,
    near_location_id int foreign key references nearby_locations
)
create table subscribe_plans
(
    id                 int identity primary key,
    name_vn            nvarchar(500),
    name_kr            nvarchar(500),
    benefits_vn        nvarchar( max),
    benefits_kr        nvarchar( max),
    number_of_property int,
    price_per_month    int
)
create table subscriptions
(
    id                 int identity primary key,
    user_id            int references users,
    subscribe_plans_id int references subscribe_plans,
    from_date          datetime,
    to_date            datetime,
    created_at         datetime
)