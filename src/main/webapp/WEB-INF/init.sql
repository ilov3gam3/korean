create table nearby_locations
(
    id      int identity primary key,
    name_vn nvarchar(255),
    name_kr nvarchar(255),
)
insert into nearby_locations(name_vn, name_kr) values (N'Sân bay', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Nhà hàng', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Quán nh?u', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Bi?n', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Núi', N'?')
insert into nearby_locations(name_vn, name_kr) values (N'Siêu th?', N'????')
insert into nearby_locations(name_vn, name_kr) values (N'Trung tâm mua s?m', N'?? ??')
insert into nearby_locations(name_vn, name_kr) values (N'Công viên', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Ngân hàng', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'ATM', N'ATM')
insert into nearby_locations(name_vn, name_kr) values (N'Ch? ?êm', N'???')
insert into nearby_locations(name_vn, name_kr) values (N'Quán cà phê', N'??')
insert into nearby_locations(name_vn, name_kr) values (N'Quán bar', N'??')
create table property_types
(
    id             int identity primary key,
    name_vn        nvarchar(255),
    name_kr        nvarchar(255),
    description_vn nvarchar(2550),
    description_kr nvarchar(2550)
)
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Chung C?', N'???', N'C?n h? ?a d?ng v?i nhi?u lo?i di?n tích, thích h?p cho cá nhân ho?c gia ?ình nh?, th??ng có các ti?n ích chung.', N'???? ???? ??? ???? ??? ??? ??? ???? ???? ???, ?? ????? ?? ??? ????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Nhà Riêng', N'?', N'Ngôi nhà ??c l?p, cung c?p không gian riêng t? v?i sân v??n, thích h?p cho gia ?ình l?n ho?c ng??i mu?n không gian riêng t?.', N'??? ?? ?? ??? ???? ??? ???? ????? ?? ??? ??? ????? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Bi?t Th?', N'??', N'Ngôi nhà cao c?p v?i không gian l?n, ti?n ích sang tr?ng, th??ng n?m trong khu ?ô th? ho?c ven bi?n.', N'?? ??? ????? ?? ??? ?? ?? ???? ?? ??? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n H? Studio', N'???? ???', N'C?n h? nh? g?n v?i không gian m?, k?t h?p gi?a phòng ng?, phòng khách và nhà b?p trong m?t không gian duy nh?t.', N'??, ??, ??? ??? ??? ??? ??? ??? ?? ?? ??????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n h? loft', N'??? ???', N'Ngôi nhà có tr?n cao, th??ng ???c chuy?n ??i t? các không gian công nghi?p, mang ??n không gian s?ng ??c ?áo.', N'??? ?? ?? ??? ??? ?? ??? ?? ??? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'nhà ph? th??ng m?i', N'??? ?????', N'Ngôi nhà k?t h?p gi?a không gian ? và không gian kinh doanh, th??ng n?m trong khu v?c th??ng m?i.', N'?? ?? ??? ???? ??? ???? ?? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n H? D?ch V?', N'??? ???', N'C?n h? ?ã ???c trang b? ??y ?? n?i th?t và d?ch v?, thích h?p cho ng??i ?ang t?m trú ho?c ?i công tác.', N'????? ??? ???? ???? ?? ????? ????? ??? ?? ????? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Nhà Ph?', N'?????', N'Ngôi nhà ???c xây d?ng li?n k? nhau, th??ng có nhi?u t?ng, mang l?i s? thu?n ti?n và không gian s?ng c?ng ??ng.', N'??? ?? ?? ???? ?? ??? ?? ???? ???? ?? ??? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'C?n H? Cao C?p', N'??? ???', N'C?n h? cao c?p v?i n?i th?t và ti?n ích sang tr?ng, thích h?p cho ng??i mu?n tr?i nghi?m cu?c s?ng ??ng c?p.', N'????? ??? ?? ??? ?? ??? ???? ?? ?? ?? ???? ?? ????? ?????.')
insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Bi?t Th? Ngh? D??ng', N'??', N'Bi?t th? n?m trong khu ngh? d??ng, mang l?i không gian yên bình và ti?n ích gi?i trí, thích h?p cho k? ngh? và ngh? cu?i tu?n.', N'??? ??? ?? ???? ?? ?? ? ??? ??? ???? ??? ?????? ??? ?????.')
create table provinces
(
    id   int identity primary key,
    name nvarchar(255)
)
insert into provinces(name) values (N'?à N?ng')
insert into provinces(name) values (N'Qu?ng Nam')
insert into provinces(name) values (N'Hu?')
insert into provinces(name) values (N'Hà N?i')
insert into provinces(name) values (N'Thành ph? H? Chí Minh')
insert into provinces(name) values (N'H?i Phòng')
create table districts
(
    id          int identity primary key,
    name        nvarchar(255),
    province_id int references provinces
)
insert into districts(name, province_id) values (N'Liên Chi?u', 1)
insert into districts(name, province_id) values (N'Thanh Khê', 1)
insert into districts(name, province_id) values (N'H?i Châu', 1)
insert into districts(name, province_id) values (N'S?n Trà', 1)
insert into districts(name, province_id) values (N'Ng? Hành S?n', 1)
insert into districts(name, province_id) values (N'C?m L?', 1)
insert into districts(name, province_id) values (N'Hòa Vang', 1)
insert into districts(name, province_id) values (N'Hoàng Sa', 1)

insert into districts(name, province_id) values (N'B?c Trà My', 2)
insert into districts(name, province_id) values (N'Duy Xuyên', 2)
insert into districts(name, province_id) values (N'??i L?c', 2)
insert into districts(name, province_id) values (N'?ông Giang', 2)
insert into districts(name, province_id) values (N'?i?n Bàn', 2)
insert into districts(name, province_id) values (N'Hi?p ??c', 2)
insert into districts(name, province_id) values (N'Nam Giang', 2)
insert into districts(name, province_id) values (N'Nam Trà My', 2)
insert into districts(name, province_id) values (N'Phú Ninh', 2)
insert into districts(name, province_id) values (N'Núi Thành', 2)
insert into districts(name, province_id) values (N'Ph??c S?n', 2)
insert into districts(name, province_id) values (N'Qu? S?n', 2)
insert into districts(name, province_id) values (N'Tây Giang', 2)
insert into districts(name, province_id) values (N'Tiên Ph??c', 2)
insert into districts(name, province_id) values (N'Th?ng Bình', 2)
insert into districts(name, province_id) values (N'th? xã H?i An', 2)
insert into districts(name, province_id) values (N'thành ph? Tam K?', 2)

insert into districts(name, province_id) values (N'Phong ?i?n', 3)
insert into districts(name, province_id) values (N'Qu?ng ?i?n', 3)
insert into districts(name, province_id) values (N'Phú L?c', 3)
insert into districts(name, province_id) values (N'Nam ?ông', 3)
insert into districts(name, province_id) values (N'A L??i', 3)
insert into districts(name, province_id) values (N'Phú Vang', 3)
insert into districts(name, province_id) values (N'H??ng Trà', 3)
insert into districts(name, province_id) values (N'H??ng Th?y', 3)

insert into districts(name, province_id) values (N'Hoàn Ki?m', 4)
insert into districts(name, province_id) values (N'??ng ?a', 4)
insert into districts(name, province_id) values (N'Ba ?ình', 4)
insert into districts(name, province_id) values (N'Hai Bà Tr?ng', 4)
insert into districts(name, province_id) values (N'Hoàng Mai', 4)
insert into districts(name, province_id) values (N'Thanh Xuân', 4)
insert into districts(name, province_id) values (N'Long Biên', 4)
insert into districts(name, province_id) values (N'Nam T? Liêm', 4)
insert into districts(name, province_id) values (N'B?c T? Liêm', 4)
insert into districts(name, province_id) values (N'Tây H?', 4)
insert into districts(name, province_id) values (N'C?u Gi?y', 4)
insert into districts(name, province_id) values (N'Hà ?ông', 4)
insert into districts(name, province_id) values (N'Ba Vì', 4)
insert into districts(name, province_id) values (N'Ch??ng M?', 4)
insert into districts(name, province_id) values (N'Phúc Th?', 4)
insert into districts(name, province_id) values (N'?an Ph??ng', 4)
insert into districts(name, province_id) values (N' ?ông Anh', 4)
insert into districts(name, province_id) values (N'Gia Lâm', 4)
insert into districts(name, province_id) values (N'Hoài ??c', 4)
insert into districts(name, province_id) values (N'Mê Linh', 4)
insert into districts(name, province_id) values (N'M? ??c', 4)
insert into districts(name, province_id) values (N'Phú Xuyên', 4)
insert into districts(name, province_id) values (N'Qu?c Oai', 4)
insert into districts(name, province_id) values (N'Sóc S?n', 4)
insert into districts(name, province_id) values (N'Th?ch Th?t', 4)
insert into districts(name, province_id) values (N'Thanh Oai', 4)
insert into districts(name, province_id) values (N'Th??ng Tín', 4)
insert into districts(name, province_id) values (N'?ng Hòa', 4)
insert into districts(name, province_id) values (N'Thanh Trì', 4)
insert into districts(name, province_id) values (N'S?n Tây', 4)


insert into districts(name, province_id) values (N'Qu?n 1', 5)
insert into districts(name, province_id) values (N'Qu?n 3', 5)
insert into districts(name, province_id) values (N'Qu?n 4', 5)
insert into districts(name, province_id) values (N'Qu?n 5', 5)
insert into districts(name, province_id) values (N'Qu?n 6', 5)
insert into districts(name, province_id) values (N'Qu?n 7', 5)
insert into districts(name, province_id) values (N'Qu?n 8', 5)
insert into districts(name, province_id) values (N'Qu?n 10', 5)
insert into districts(name, province_id) values (N'Qu?n 11', 5)
insert into districts(name, province_id) values (N'Tân Phú', 5)
insert into districts(name, province_id) values (N'Tân Bình', 5)
insert into districts(name, province_id) values (N'Gò V?p', 5)
insert into districts(name, province_id) values (N'Phú Nhu?n', 5)
insert into districts(name, province_id) values (N'Bình Th?nh', 5)
insert into districts(name, province_id) values (N'Th? ??c', 5)
insert into districts(name, province_id) values (N'Nhà Bè', 5)
insert into districts(name, province_id) values (N'Bình Chánh', 5)
insert into districts(name, province_id) values (N'C?n Gi?', 5)


insert into districts(name, province_id) values (N'H?ng Bàng', 6)
insert into districts(name, province_id) values (N'Lê Chân', 6)
insert into districts(name, province_id) values (N'Ngô Quy?n', 6)
insert into districts(name, province_id) values (N'An D??ng', 6)
insert into districts(name, province_id) values (N'An Lão', 6)
insert into districts(name, province_id) values (N'Cát Bà', 6)
insert into districts(name, province_id) values (N'Cát H?i', 6)
insert into districts(name, province_id) values (N'H?i An', 6)
insert into districts(name, province_id) values (N'Ki?n Th?y', 6)
insert into districts(name, province_id) values (N'Th?y Nguyên', 6)
insert into districts(name, province_id) values (N'Tiên Lãng', 6)
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
insert into amenities(name_vn, name_kr) values (N'?i?u hòa nóng l?nh', N'???/??')
insert into amenities(name_vn, name_kr) values (N'B?a sáng mi?n phí', N'?? ?? ??')
insert into amenities(name_vn, name_kr) values (N'Qu?y l? tân 24 gi?', N'24?? ??? ???')
insert into amenities(name_vn, name_kr) values (N'D?ch v? phòng', N'? ???')
insert into amenities(name_vn, name_kr) values (N'Bãi ??u xe', N'???')
insert into amenities(name_vn, name_kr) values (N'??a ?ón sân bay', N'?? ??')
insert into amenities(name_vn, name_kr) values (N'Trung tâm th? d?c', N'???? ??')
insert into amenities(name_vn, name_kr) values (N'H? b?i', N'???')
insert into amenities(name_vn, name_kr) values (N'D?ch v? v?n phòng', N'???? ??')
insert into amenities(name_vn, name_kr) values (N'D?ch v? h??ng d?n khách', N'???? ???')
insert into amenities(name_vn, name_kr) values (N'Cho phép thú c?ng', N'?? ?? ?? ??')
insert into amenities(name_vn, name_kr) values (N'Trung tâm Spa/ch?m sóc s?c kh?e', N'??/???? ??')
insert into amenities(name_vn, name_kr) values (N'Khu v?c Lounge/Bar', N'???/? ??')
insert into amenities(name_vn, name_kr) values (N'D?ch v? gi?t là', N'?? ???')
insert into amenities(name_vn, name_kr) values (N'Không gian h?i h?p/s? ki?n', N'??/??? ??')
insert into amenities(name_vn, name_kr) values (N'Khu vui ch?i tr? em', N'??? ?? ??')
insert into amenities(name_vn, name_kr) values (N'Két an toàn', N'??? ??')
insert into amenities(name_vn, name_kr) values (N'Phòng dành cho ng??i khuy?t t?t', N'???? ?? ??')
insert into amenities(name_vn, name_kr) values (N'Tùy ch?n gi?i trí', N'?????? ??')
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