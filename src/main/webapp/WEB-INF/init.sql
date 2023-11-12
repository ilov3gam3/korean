create table nearby_locations(
                                 id             int identity primary key,
                                 name_vn        nvarchar(255),
                                 name_kr        nvarchar(255),
)
create table property_types
(
    id             int identity primary key,
    name_vn        nvarchar(255),
    name_kr        nvarchar(255),
    description_vn nvarchar(2550),
    description_kr nvarchar(2550)
)

create table provinces
(
    id   int identity primary key,
    name nvarchar(255)
)

create table districts
(
    id          int identity primary key,
    name        nvarchar(255),
    province_id int references provinces
)

create table users
(
    id             int identity primary key,
    name           nvarchar(255) not null,
    email          nvarchar(255) not null,
    password       nvarchar(255),
    avatar         nvarchar(255) not null,
    phone          nvarchar(255),
    dob            date,
    nationality nvarchar(255),
    national_id    nvarchar(255),
    front_id_card  nvarchar(255),
    back_id_card   nvarchar(255),
    hash           nvarchar(255),
    is_verified    bit           not null,
    cards_verified bit           not null,
    is_admin       bit           not null,
)
create table amenities(
                          id             int identity primary key,
                          name_vn        nvarchar(255),
                          name_kr        nvarchar(255),
)

create table properties
(
    id             int identity primary key,
    name_vn        nvarchar(500),
    name_kr        nvarchar(500),
    property_type  int references property_types,
    description_vn nvarchar(max),
    description_kr nvarchar(max),
    price          int,
    floor_numbers int,
    at_floor int,
    district_id    int references districts,
    address       nvarchar(500),
    bedrooms       int,
    bathrooms      int,
    area           int,
    user_id        int references users,
    hidden         bit,
    for_sale       bit,
    sold bit,
    created_at     datetime
)
create table property_amenities(
                                   id             int identity primary key,
                                   property_id int foreign key references properties,
                                   amenity_id int foreign key references amenities
)
create table property_images
(
    id          int identity primary key,
    property_id int references properties,
    path        nvarchar(500),
    is_thumb_nail bit
)
create table property_near_location(
                                       id             int identity primary key,
                                       property_id int foreign key references properties,
                                       near_location_id int foreign key references nearby_locations
)