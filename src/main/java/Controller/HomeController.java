package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Database.DB;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.Properties;

public class HomeController {
    @WebServlet("/home")
    public static class Index extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        }
    }

    @WebServlet("/database")
    public static class Database extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String catalog = null;
            try {
                catalog = DB.getConnection().getCatalog();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            req.setAttribute("catalog", catalog);
            req.getRequestDispatcher("/views/database.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            DB.dropAllTables();
            String sqlFilePath = getServletContext().getRealPath("/WEB-INF/init.sql");
            /*StringBuilder sqlContent = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(Files.newInputStream(Paths.get(sqlFilePath)), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sqlContent.append(line).append("\n");
                }
            }
            System.out.println(sqlContent);*/
            String sqlContent = "create table nearby_locations\n" +
                    "(\n" +
                    "    id      int identity primary key,\n" +
                    "    name_vn nvarchar(255),\n" +
                    "    name_kr nvarchar(255),\n" +
                    ")\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Sân bay', N'공항')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Nhà hàng', N'식당')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Quán nhậu', N'술집')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Biển', N'바다')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Núi', N'산')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Siêu thị', N'슈퍼마켓')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Trung tâm mua sắm', N'쇼핑 센터')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Công viên', N'공원')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Ngân hàng', N'은행')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'ATM', N'ATM')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Chợ đêm', N'야시장')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Quán cà phê', N'카페')\n" +
                    "insert into nearby_locations(name_vn, name_kr) values (N'Quán bar', N'술집')\n" +
                    "create table property_types\n" +
                    "(\n" +
                    "    id             int identity primary key,\n" +
                    "    name_vn        nvarchar(255),\n" +
                    "    name_kr        nvarchar(255),\n" +
                    "    description_vn nvarchar(2550),\n" +
                    "    description_kr nvarchar(2550)\n" +
                    ")\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Chung Cư', N'아파트', N'Căn hộ đa dạng với nhiều loại diện tích, thích hợp cho cá nhân hoặc gia đình nhỏ, thường có các tiện ích chung.', N'아파트는 개인이나 소규모 가족에게 적합한 다양한 유형의 공간으로 구성되어 있으며, 공동 편의시설을 갖춘 경우가 많습니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Nhà Riêng', N'집', N'Ngôi nhà độc lập, cung cấp không gian riêng tư với sân vườn, thích hợp cho gia đình lớn hoặc người muốn không gian riêng tư.', N'정원이 딸린 개인 공간을 제공하는 독립형 주택으로 대가족이나 개인 공간을 원하는 사람들에게 적합합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Biệt Thự', N'별장', N'Ngôi nhà cao cấp với không gian lớn, tiện ích sang trọng, thường nằm trong khu đô thị hoặc ven biển.', N'넓은 공간과 고급스러운 편의 시설을 갖춘 고급 주택으로 주로 도시나 해안 지역에 위치합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Căn Hộ Studio', N'스튜디오 아파트', N'Căn hộ nhỏ gọn với không gian mở, kết hợp giữa phòng ngủ, phòng khách và nhà bếp trong một không gian duy nhất.', N'침실, 거실, 주방을 하나의 공간에 결합한 개방형 공간을 갖춘 소형 아파트입니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Căn hộ loft', N'로프트 아파트', N'Ngôi nhà có trần cao, thường được chuyển đổi từ các không gian công nghiệp, mang đến không gian sống độc đáo.', N'집에는 종종 산업 공간을 개조한 높은 천장이 있어 독특한 생활 공간을 제공합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'nhà phố thương mại', N'상업용 타운하우스', N'Ngôi nhà kết hợp giữa không gian ở và không gian kinh doanh, thường nằm trong khu vực thương mại.', N'집은 주거 공간과 비즈니스 공간을 결합하며 종종 상업 지역에 위치합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Căn Hộ Dịch Vụ', N'서비스 아파트', N'Căn hộ đã được trang bị đầy đủ nội thất và dịch vụ, thích hợp cho người đang tạm trú hoặc đi công tác.', N'아파트에는 가구와 서비스가 완비되어 있어 일시적으로 머무르거나 출장을 가는 사람들에게 적합합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Nhà Phố', N'타운하우스', N'Ngôi nhà được xây dựng liền kề nhau, thường có nhiều tầng, mang lại sự thuận tiện và không gian sống cộng đồng.', N'주택은 서로 옆에 지어지며 종종 층수가 많아 편리함과 커뮤니티 생활 공간을 제공합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Căn Hộ Cao Cấp', N'럭셔리 아파트', N'Căn hộ cao cấp với nội thất và tiện ích sang trọng, thích hợp cho người muốn trải nghiệm cuộc sống đẳng cấp.', N'고급스러운 가구와 편의 시설을 갖춘 럭셔리 아파트로 품격 있는 삶을 경험하고 싶은 사람들에게 적합합니다.')\n" +
                    "insert into property_types(name_vn, name_kr, description_vn, description_kr) values (N'Biệt Thự Nghỉ Dưỡng', N'의지', N'Biệt thự nằm trong khu nghỉ dưỡng, mang lại không gian yên bình và tiện ích giải trí, thích hợp cho kỳ nghỉ và nghỉ cuối tuần.', N'빌라는 리조트 내에 위치하고 있어 휴가 및 주말에 적합한 평화로운 공간과 엔터테인먼트 시설을 제공합니다.')\n" +
                    "create table provinces\n" +
                    "(\n" +
                    "    id   int identity primary key,\n" +
                    "    name nvarchar(255)\n" +
                    ")\n" +
                    "insert into provinces(name) values (N'Đà Nẵng')\n" +
                    "insert into provinces(name) values (N'Quảng Nam')\n" +
                    "insert into provinces(name) values (N'Huế')\n" +
                    "insert into provinces(name) values (N'Hà Nội')\n" +
                    "insert into provinces(name) values (N'Thành phố Hồ Chí Minh')\n" +
                    "insert into provinces(name) values (N'Hải Phòng')\n" +
                    "create table districts\n" +
                    "(\n" +
                    "    id          int identity primary key,\n" +
                    "    name        nvarchar(255),\n" +
                    "    province_id int references provinces\n" +
                    ")\n" +
                    "insert into districts(name, province_id) values (N'Liên Chiểu', 1)\n" +
                    "insert into districts(name, province_id) values (N'Thanh Khê', 1)\n" +
                    "insert into districts(name, province_id) values (N'Hải Châu', 1)\n" +
                    "insert into districts(name, province_id) values (N'Sơn Trà', 1)\n" +
                    "insert into districts(name, province_id) values (N'Ngũ Hành Sơn', 1)\n" +
                    "insert into districts(name, province_id) values (N'Cẩm Lệ', 1)\n" +
                    "insert into districts(name, province_id) values (N'Hòa Vang', 1)\n" +
                    "insert into districts(name, province_id) values (N'Hoàng Sa', 1)\n" +
                    "\n" +
                    "insert into districts(name, province_id) values (N'Bắc Trà My', 2)\n" +
                    "insert into districts(name, province_id) values (N'Duy Xuyên', 2)\n" +
                    "insert into districts(name, province_id) values (N'Đại Lộc', 2)\n" +
                    "insert into districts(name, province_id) values (N'Đông Giang', 2)\n" +
                    "insert into districts(name, province_id) values (N'Điện Bàn', 2)\n" +
                    "insert into districts(name, province_id) values (N'Hiệp Đức', 2)\n" +
                    "insert into districts(name, province_id) values (N'Nam Giang', 2)\n" +
                    "insert into districts(name, province_id) values (N'Nam Trà My', 2)\n" +
                    "insert into districts(name, province_id) values (N'Phú Ninh', 2)\n" +
                    "insert into districts(name, province_id) values (N'Núi Thành', 2)\n" +
                    "insert into districts(name, province_id) values (N'Phước Sơn', 2)\n" +
                    "insert into districts(name, province_id) values (N'Quế Sơn', 2)\n" +
                    "insert into districts(name, province_id) values (N'Tây Giang', 2)\n" +
                    "insert into districts(name, province_id) values (N'Tiên Phước', 2)\n" +
                    "insert into districts(name, province_id) values (N'Thăng Bình', 2)\n" +
                    "insert into districts(name, province_id) values (N'thị xã Hội An', 2)\n" +
                    "insert into districts(name, province_id) values (N'thành phố Tam Kỳ', 2)\n" +
                    "\n" +
                    "insert into districts(name, province_id) values (N'Phong Điền', 3)\n" +
                    "insert into districts(name, province_id) values (N'Quảng Điền', 3)\n" +
                    "insert into districts(name, province_id) values (N'Phú Lộc', 3)\n" +
                    "insert into districts(name, province_id) values (N'Nam Đông', 3)\n" +
                    "insert into districts(name, province_id) values (N'A Lưới', 3)\n" +
                    "insert into districts(name, province_id) values (N'Phú Vang', 3)\n" +
                    "insert into districts(name, province_id) values (N'Hương Trà', 3)\n" +
                    "insert into districts(name, province_id) values (N'Hương Thủy', 3)\n" +
                    "\n" +
                    "insert into districts(name, province_id) values (N'Hoàn Kiếm', 4)\n" +
                    "insert into districts(name, province_id) values (N'Đống Đa', 4)\n" +
                    "insert into districts(name, province_id) values (N'Ba Đình', 4)\n" +
                    "insert into districts(name, province_id) values (N'Hai Bà Trưng', 4)\n" +
                    "insert into districts(name, province_id) values (N'Hoàng Mai', 4)\n" +
                    "insert into districts(name, province_id) values (N'Thanh Xuân', 4)\n" +
                    "insert into districts(name, province_id) values (N'Long Biên', 4)\n" +
                    "insert into districts(name, province_id) values (N'Nam Từ Liêm', 4)\n" +
                    "insert into districts(name, province_id) values (N'Bắc Từ Liêm', 4)\n" +
                    "insert into districts(name, province_id) values (N'Tây Hồ', 4)\n" +
                    "insert into districts(name, province_id) values (N'Cầu Giấy', 4)\n" +
                    "insert into districts(name, province_id) values (N'Hà Đông', 4)\n" +
                    "insert into districts(name, province_id) values (N'Ba Vì', 4)\n" +
                    "insert into districts(name, province_id) values (N'Chương Mỹ', 4)\n" +
                    "insert into districts(name, province_id) values (N'Phúc Thọ', 4)\n" +
                    "insert into districts(name, province_id) values (N'Đan Phượng', 4)\n" +
                    "insert into districts(name, province_id) values (N' Đông Anh', 4)\n" +
                    "insert into districts(name, province_id) values (N'Gia Lâm', 4)\n" +
                    "insert into districts(name, province_id) values (N'Hoài Đức', 4)\n" +
                    "insert into districts(name, province_id) values (N'Mê Linh', 4)\n" +
                    "insert into districts(name, province_id) values (N'Mỹ Đức', 4)\n" +
                    "insert into districts(name, province_id) values (N'Phú Xuyên', 4)\n" +
                    "insert into districts(name, province_id) values (N'Quốc Oai', 4)\n" +
                    "insert into districts(name, province_id) values (N'Sóc Sơn', 4)\n" +
                    "insert into districts(name, province_id) values (N'Thạch Thất', 4)\n" +
                    "insert into districts(name, province_id) values (N'Thanh Oai', 4)\n" +
                    "insert into districts(name, province_id) values (N'Thường Tín', 4)\n" +
                    "insert into districts(name, province_id) values (N'Ứng Hòa', 4)\n" +
                    "insert into districts(name, province_id) values (N'Thanh Trì', 4)\n" +
                    "insert into districts(name, province_id) values (N'Sơn Tây', 4)\n" +
                    "\n" +
                    "\n" +
                    "insert into districts(name, province_id) values (N'Quận 1', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 3', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 4', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 5', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 6', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 7', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 8', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 10', 5)\n" +
                    "insert into districts(name, province_id) values (N'Quận 11', 5)\n" +
                    "insert into districts(name, province_id) values (N'Tân Phú', 5)\n" +
                    "insert into districts(name, province_id) values (N'Tân Bình', 5)\n" +
                    "insert into districts(name, province_id) values (N'Gò Vấp', 5)\n" +
                    "insert into districts(name, province_id) values (N'Phú Nhuận', 5)\n" +
                    "insert into districts(name, province_id) values (N'Bình Thạnh', 5)\n" +
                    "insert into districts(name, province_id) values (N'Thủ Đức', 5)\n" +
                    "insert into districts(name, province_id) values (N'Nhà Bè', 5)\n" +
                    "insert into districts(name, province_id) values (N'Bình Chánh', 5)\n" +
                    "insert into districts(name, province_id) values (N'Cần Giờ', 5)\n" +
                    "\n" +
                    "\n" +
                    "insert into districts(name, province_id) values (N'Hồng Bàng', 6)\n" +
                    "insert into districts(name, province_id) values (N'Lê Chân', 6)\n" +
                    "insert into districts(name, province_id) values (N'Ngô Quyền', 6)\n" +
                    "insert into districts(name, province_id) values (N'An Dương', 6)\n" +
                    "insert into districts(name, province_id) values (N'An Lão', 6)\n" +
                    "insert into districts(name, province_id) values (N'Cát Bà', 6)\n" +
                    "insert into districts(name, province_id) values (N'Cát Hải', 6)\n" +
                    "insert into districts(name, province_id) values (N'Hải An', 6)\n" +
                    "insert into districts(name, province_id) values (N'Kiến Thụy', 6)\n" +
                    "insert into districts(name, province_id) values (N'Thủy Nguyên', 6)\n" +
                    "insert into districts(name, province_id) values (N'Tiên Lãng', 6)\n" +
                    "insert into districts(name, province_id) values (N'Vĩnh Bảo', 6)\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "create table users\n" +
                    "(\n" +
                    "    id             int identity primary key,\n" +
                    "    name           nvarchar(255) not null,\n" +
                    "    email          nvarchar(255) not null,\n" +
                    "    password       nvarchar(255),\n" +
                    "    avatar         nvarchar(255) not null,\n" +
                    "    phone          nvarchar(255),\n" +
                    "    dob            date,\n" +
                    "    nationality    nvarchar(255),\n" +
                    "    national_id    nvarchar(255),\n" +
                    "    front_id_card  nvarchar(255),\n" +
                    "    back_id_card   nvarchar(255),\n" +
                    "    hash           nvarchar(255),\n" +
                    "    is_verified    bit not null,\n" +
                    "    cards_verified bit not null,\n" +
                    "    is_admin       bit not null,\n" +
                    ")\n" +
                    "INSERT INTO korean.dbo.users (name, email, password, avatar, phone, dob, nationality, national_id, front_id_card, back_id_card, hash, is_verified, cards_verified, is_admin) VALUES (N'Admin', N'admin@gmail.com', N'admin123', N'/files/default-avatar.webp', N'0123456789', N'2002-08-05', N'Viet Nam', N'048202001288', null, null, null, 1, 0, 1);\n" +
                    "INSERT INTO korean.dbo.users (name, email, password, avatar, phone, dob, nationality, national_id, front_id_card, back_id_card, hash, is_verified, cards_verified, is_admin) VALUES (N'Quang Minh Trần', N'tranquangminh116@gmail.com', N'050820021', N'https://lh3.googleusercontent.com/a/ACg8ocIt8XtJpqw1ntOyeAJF8XyacXD7_UdomYCc7OyZ4mN5vg=s96-c', N'0123456789', N'2002-08-05', N'Viet Nam', N'048202001288', null, null, null, 1, 0, 0);\n" +
                    "create table amenities\n" +
                    "(\n" +
                    "    id      int identity primary key,\n" +
                    "    name_vn nvarchar(255),\n" +
                    "    name_kr nvarchar(255),\n" +
                    ")\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Free Wifi', N'무료 와이파이')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Điều hòa nóng lạnh', N'에어컨/난방')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Bữa sáng miễn phí', N'무료 아침 식사')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Quầy lễ tân 24 giờ', N'24시간 프런트 데스크')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Dịch vụ phòng', N'룸 서비스')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Bãi đậu xe', N'주차장')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Đưa đón sân bay', N'공항 픽업')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Trung tâm thể dục', N'피트니스 센터')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Hồ bơi', N'수영장')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Dịch vụ văn phòng', N'비즈니스 센터')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Dịch vụ hướng dẫn khách', N'컨시어지 서비스')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Cho phép thú cưng', N'애완 동물 동행 허용')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Trung tâm Spa/chăm sóc sức khỏe', N'스파/헬스케어 센터')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Khu vực Lounge/Bar', N'라운지/바 공간')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Dịch vụ giặt là', N'세탁 서비스')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Không gian hội họp/sự kiện', N'회의/이벤트 공간')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Khu vui chơi trẻ em', N'어린이 놀이 공간')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Két an toàn', N'안전한 금고')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Phòng dành cho người khuyết tật', N'장애인을 위한 객실')\n" +
                    "insert into amenities(name_vn, name_kr) values (N'Tùy chọn giải trí', N'엔터테인먼트 옵션')\n" +
                    "create table properties\n" +
                    "(\n" +
                    "    id             int identity primary key,\n" +
                    "    name_vn        nvarchar(500),\n" +
                    "    name_kr        nvarchar(500),\n" +
                    "    property_type  int references property_types,\n" +
                    "    description_vn nvarchar( max),\n" +
                    "    description_kr nvarchar( max),\n" +
                    "    price          float,\n" +
                    "    floor_numbers  int,\n" +
                    "    at_floor       int,\n" +
                    "    district_id    int references districts,\n" +
                    "    address        nvarchar(500),\n" +
                    "    bedrooms       int,\n" +
                    "    bathrooms      int,\n" +
                    "    area           int,\n" +
                    "    user_id        int references users,\n" +
                    "    hidden         bit,\n" +
                    "    for_sale       bit,\n" +
                    "    sold           bit,\n" +
                    "    created_at     datetime,\n" +
                    "    gg_map_api nvarchar(1000),\n" +
                    ")\n" +
                    "INSERT INTO korean.dbo.properties (name_vn, name_kr, property_type, description_vn, description_kr, price, floor_numbers, at_floor, district_id, address, bedrooms, bathrooms, area, user_id, hidden, for_sale, sold, created_at) VALUES (N'căn hộ cao cấp', N'럭셔리 아파트먼트 (Luxury Apartments)', 9, N'Khu căn hộ cao cấp tại Đà Nẵng · Regal Complex: Dự án căn hộ tại Đà Nẵng · Căn hộ Felicia Oceanview Apart – Hotel Đà Nẵng · Căn hộ Asiana Luxury Residences Đà Nẵng.', N'다낭의 고급 아파트 · Regal Complex : 다낭의 아파트 프로젝트 · 아파트 펠리시아 오션뷰 아파트 – 호텔 다낭 · 아시아나 럭셔리 레지던스 다낭.', 28000000, 30, 10, 3, N'Đào Duy Tùng, Ngũ Hành Sơn, Đà Nẵng', 3, 1, 150, 2, 0, 0, 0, N'2023-11-24 11:14:52.000');\n" +
                    "INSERT INTO korean.dbo.properties (name_vn, name_kr, property_type, description_vn, description_kr, price, floor_numbers, at_floor, district_id, address, bedrooms, bathrooms, area, user_id, hidden, for_sale, sold, created_at) VALUES (N'Biệt thự ABC', N'ABC 빌라', 3, N'con chó', N'개', 10000000000, 3, 1, 7, N'Hoà Xuân', 5, 3, 200, 2, 0, 1, 0, N'2023-11-24 14:52:51.000');\n" +
                    "create table property_amenities\n" +
                    "(\n" +
                    "    id          int identity primary key,\n" +
                    "    property_id int foreign key references properties,\n" +
                    "    amenity_id  int foreign key references amenities\n" +
                    ")\n" +
                    "INSERT INTO korean.dbo.property_amenities (property_id, amenity_id) VALUES (1, 1);\n" +
                    "INSERT INTO korean.dbo.property_amenities (property_id, amenity_id) VALUES (1, 2);\n" +
                    "INSERT INTO korean.dbo.property_amenities (property_id, amenity_id) VALUES (1, 6);\n" +
                    "INSERT INTO korean.dbo.property_amenities (property_id, amenity_id) VALUES (2, 15);\n" +
                    "INSERT INTO korean.dbo.property_amenities (property_id, amenity_id) VALUES (2, 12);\n" +
                    "INSERT INTO korean.dbo.property_amenities (property_id, amenity_id) VALUES (2, 1);\n" +
                    "create table property_images\n" +
                    "(\n" +
                    "    id            int identity primary key,\n" +
                    "    property_id   int references properties,\n" +
                    "    path          nvarchar(500),\n" +
                    "    is_thumb_nail bit\n" +
                    ")\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (1, N'/files/3815cdf2-4624-45dc-a34b-90e2012ace27.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (1, N'/files/fd7b4c92-7bfa-48cc-b516-ad1aa44f0bef.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (1, N'/files/12a9ac08-85e5-4895-af89-4d28fd34c6ce.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (1, N'/files/da54f703-5c38-4e1d-9870-93ebcddaaf53.jpeg', 1);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (1, N'/files/128930ad-2651-42b8-94cc-978faf81d084.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (2, N'/files/669c4ea6-8f1c-4cea-afcd-4d381f78ea13.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (2, N'/files/f3c7a0a9-c51a-459f-8a5a-c3192533a0fb.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (2, N'/files/007552f5-5b4e-4d93-bfc1-e1146c457886.jpg', 1);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (2, N'/files/0ebe01d3-0f3f-426a-81cb-f65ceef1172d.jpg', 0);\n" +
                    "INSERT INTO korean.dbo.property_images (property_id, path, is_thumb_nail) VALUES (2, N'/files/74b46816-80e9-4886-ae0f-a3bd62b33a84.jpg', 0);\n" +
                    "\n" +
                    "create table property_near_location\n" +
                    "(\n" +
                    "    id               int identity primary key,\n" +
                    "    property_id      int foreign key references properties,\n" +
                    "    near_location_id int foreign key references nearby_locations\n" +
                    ")\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (1, 2);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (1, 5);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (1, 7);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (1, 10);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (2, 4);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (2, 6);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (2, 11);\n" +
                    "INSERT INTO korean.dbo.property_near_location (property_id, near_location_id) VALUES (2, 2);\n" +
                    "create table subscribe_plans\n" +
                    "(\n" +
                    "    id                 int identity primary key,\n" +
                    "    name_vn            nvarchar(500),\n" +
                    "    name_kr            nvarchar(500),\n" +
                    "    number_of_property int,\n" +
                    "    price_per_month    int,\n" +
                    "    number_of_comments int,\n" +
                    "    number_of_words_per_cmt int,\n" +
                    "    hidden bit\n" +
                    ")\n" +
                    "insert into subscribe_plans(name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, hidden) values (N'Bạc', N'은', 5, 100000, 20, 20, 'false')\n" +
                    "insert into subscribe_plans(name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, hidden) values (N'Vàng', N'노란색', 10, 200000, 30, 30, 'false')\n" +
                    "insert into subscribe_plans(name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, hidden) values (N'Kim cương', N'다이아몬드', 15, 300000, 40, 40, 'false')\n" +
                    "create table subscriptions\n" +
                    "(\n" +
                    "    id                 int identity primary key,\n" +
                    "    user_id            int references users,\n" +
                    "    subscribe_plans_id int references subscribe_plans,\n" +
                    "    from_date          datetime,\n" +
                    "    to_date            datetime,\n" +
                    "    number_of_property int,\n" +
                    "    price_per_month    int,\n" +
                    "    number_of_comments int,\n" +
                    "    number_of_words_per_cmt int,\n" +
                    "    discount int,\n" +
                    "    price_to_pay int,\n" +
                    "    vnp_BankCode          varchar(50),\n" +
                    "    vnp_TransactionNo     varchar(50),\n" +
                    "    vnp_TransactionStatus varchar(50),\n" +
                    "    vnp_OrderInfo         varchar(50),\n" +
                    "    vnp_TxnRef            varchar(50),\n" +
                    "    vnp_CardType          varchar(50),\n" +
                    "    vnp_BankTranNo        varchar(50),\n" +
                    "    create_order_at       datetime,\n" +
                    "    paid_at               datetime,\n" +
                    ")\n";
            boolean check = DB.executeUpdate(String.valueOf(sqlContent));
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
