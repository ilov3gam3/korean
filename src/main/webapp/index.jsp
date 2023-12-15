<%@ page import="java.util.ArrayList" %>
<%@ page import="Database.DB" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="views/master/head.jsp" %>
    <!-- Header Start -->
    <div class="container-fluid header bg-white p-0">
        <div class="row g-0 align-items-center flex-column-reverse flex-md-row">
            <div class="col-md-6 p-5 mt-lg-5">
                <h1 class="display-5 animated fadeIn mb-4"><%=language.getProperty("slogan")%></h1>
                <p class="animated fadeIn mb-4 pb-2">Vero elitr justo clita lorem. Ipsum dolor at sed stet
                    sit diam no. Kasd rebum ipsum et diam justo clita et kasd rebum sea elitr.</p>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary py-3 px-5 me-3 animated fadeIn">Get Started</a>
            </div>
            <div class="col-md-6 animated fadeIn">
                <div class="owl-carousel header-carousel">
                    <div class="owl-carousel-item">
                        <img class="img-fluid" src="${pageContext.request.contextPath}/assets/img/carousel-1.jpg" alt="">
                    </div>
                    <div class="owl-carousel-item">
                        <img class="img-fluid" src="${pageContext.request.contextPath}/assets/img/carousel-2.jpg" alt="">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Header End -->
    <!-- Category Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="text-center mx-auto mb-5 wow fadeInUp" data-wow-delay="0.1s" style="max-width: 600px;">
                <h1 class="mb-3"><%=language.getProperty("search_property_type")%></h1>
                <p>Eirmod sed ipsum dolor sit rebum labore magna erat. Tempor ut dolore lorem kasd vero ipsum sit eirmod sit. Ipsum diam justo sed rebum vero dolor duo.</p>
            </div>
            <div class="row g-4">
                <%ArrayList<MyObject> property_types = DB.getData("select top 4 property_types.*, count(properties.id) as numbers from property_types left join properties on property_types.id = properties.property_type\n" +
                        "group by property_types.id, property_types.name_vn, property_types.name_kr, property_types.description_vn, property_types.description_kr\n" +
                        "order by count(properties.id) desc",new String[]{"id", "name_vn","name_kr", "description_vn", "description_kr", "numbers"});%>
                <% for (int i = 0; i < property_types.size(); i++) { %>
                <div title="<%=lang.equals("kr") ? property_types.get(i).getDescription_kr() : property_types.get(i).getDescription_vn()%>" class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="<%=String.format("%.1f", (i%4)*0.2+0.1)%>s">
                    <a class="cat-item d-block bg-light text-center rounded p-3" href="${pageContext.request.contextPath}/search?para=<%=property_types.get(i).getId()%>">
                        <div class="rounded p-4">
                            <div class="icon mb-3">
                                <img class="img-fluid" src="${pageContext.request.contextPath}/assets/img/icon-apartment.png" alt="Icon">
                            </div>
                            <%if (lang.equals("kr")){%>
                                <h6><%=property_types.get(i).getName_kr()%></h6>
                                <span><%=property_types.get(i).getNumbers()%> 집</span>
                            <% } else { %>
                                <h6><%=property_types.get(i).getName_vn()%></h6>
                                <span><%=property_types.get(i).getNumbers()%> Nhà ở</span>
                            <% } %>
                        </div>
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    <!-- Category End -->
    <div id="property_listing_123">
    <!-- About Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="row g-5 align-items-center">
                <div class="col-lg-6 wow fadeIn" data-wow-delay="0.1s">
                    <div class="about-img position-relative overflow-hidden p-5 pe-0">
                        <img class="img-fluid w-100" src="${pageContext.request.contextPath}/assets/img/about.jpg">
                    </div>
                </div>
                <div class="col-lg-6 wow fadeIn" data-wow-delay="0.5s">
                    <h1 class="mb-4">{{'<%=language.getProperty("best_review")%>'.replace("xxx", location.name)}}</h1>
                    <h3 class="mb-4">{{'<%=language.getProperty("lang")%>' == 'vn' ? top_property.name_vn : top_property.name_kr}}</h3>
                    <p class="mb-4">{{'<%=language.getProperty("lang")%>' == 'vn' ? top_property.description_vn : top_property.description_kr}}</p>
                    <p><i class="fa fa-check text-primary me-3"></i><%=language.getProperty("avg_review")%>: {{top_property.numbers}}⭐</p>
                    <p><i class="fa fa-check text-primary me-3"></i><%=language.getProperty("add_property_address")%>: {{top_property.address}}, {{getDistrictName(top_property.district_id)}}, {{getProvinceName(top_property.province_id)}}</p>
                    <a class="btn btn-primary py-3 px-5 mt-3" :href="'<%=request.getContextPath()%>' + '/view-property?id=' + top_property.id"><%=language.getProperty("details")%></a>
                </div>
            </div>
        </div>
    </div>
    <!-- About End -->
    <!-- Property List Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="row g-0 gx-5 align-items-end">
                <div class="col-lg-6">
                    <div class="text-start mx-auto mb-5 wow slideInLeft" data-wow-delay="0.1s">
                        <h1 class="mb-3">{{ '<%=language.getProperty("property_listing")%>'.replace("XXX" ,this.location.name) }}</h1>
                        <p>Eirmod sed ipsum dolor sit rebum labore magna erat. Tempor ut dolore lorem kasd vero ipsum sit eirmod sit diam justo sed rebum.</p>
                    </div>
                </div>
            </div>
            <div class="tab-content">
                <div id="tab-1" class="tab-pane fade show p-0 active">
                    <div class="row g-4">
                        <template v-for="(value, key) in properties">
                            <div class="col-lg-4 col-md-6 wow fadeInUp">
                                <div class="property-item rounded overflow-hidden">
                                    <div class="position-relative overflow-hidden">
                                        <a href=""><img class="img-fluid" style="width: 100%; height: 100%" :src="context + value.thumbnail" alt=""></a>
                                        <div class="bg-primary rounded text-white position-absolute start-0 top-0 m-4 py-1 px-3">{{value.for_sale == '1' ? '<%=language.getProperty("search_sale")%>' : '<%=language.getProperty("search_rent")%>'}}</div>
                                        <div class="bg-white rounded-top text-primary position-absolute start-0 bottom-0 mx-4 pt-1 px-3">{{lang == 'vn' ? value.property_type_name_vn : value.property_type_name_kr}}</div>
                                    </div>
                                    <div class="p-4 pb-0">
                                        <h5 class="text-primary mb-3">{{Number(value.price).toLocaleString()}}₫</h5>
                                        <a class="d-block h5 mb-2" :href="context + '/view-property?id=' + value.id">{{lang == 'vn' ? value.name_vn : value.name_kr}}</a>
                                        <p><i class="fa fa-map-marker-alt text-primary me-2"></i>{{value.address}}, {{getDistrictName(value.district_id)}}, {{getProvinceName(value.province_id)}}</p>
                                    </div>
                                    <div class="d-flex border-top">
                                        <small class="flex-fill text-center border-end py-2"><i class="fa fa-ruler-combined text-primary me-2"></i>{{value.area}} m²</small>
                                        <small class="flex-fill text-center border-end py-2"><i class="fa fa-bed text-primary me-2"></i>{{value.bedrooms}} <%=language.getProperty("search_bedrooms")%></small>
                                        <small class="flex-fill text-center py-2"><i class="fa fa-bath text-primary me-2"></i>{{value.bathrooms}} <%=language.getProperty("search_bathrooms")%></small>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Property List End -->
</div>
    <script>
    var property_listing_123 = new Vue({
        el: "#property_listing_123",
        data:{
            location: {},
            properties : [],
            context: '<%=request.getContextPath()%>',
            lang: '<%=lang%>',
            districts: [],
            provinces: [],
            top_property : {}
        },
        created(){
            axios.get('<%=request.getContextPath()%>/api/get-locations')
                .then((res)=>{
                    this.provinces = JSON.parse(res.data.provinces_list)
                    this.districts = JSON.parse(res.data.districts_list)
                })
        },
        methods:{
            getDistrictName(id){
                for (let i = 0; i < this.districts.length; i++) {
                    if (this.districts[i].id == id){
                        return this.districts[i].name
                    }
                }
            },
            getProvinceName(id){
                for (let i = 0; i < this.provinces.length; i++) {
                    if (this.provinces[i].id == id){
                        return this.provinces[i].name
                    }
                }
            },
        },
    })
</script>
    <!-- Call to Action Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="bg-light rounded p-3">
                <div class="bg-white rounded p-4" style="border: 1px dashed rgba(0, 185, 142, .3)">
                    <div class="row g-5 align-items-center">
                        <div class="col-lg-6 wow fadeIn" data-wow-delay="0.1s">
                            <img style="width: 571px; height: 400px; object-fit: cover" class="img-fluid rounded w-100" src="${pageContext.request.contextPath}/assets/img/call-to-action1.jpg" alt="">
                        </div>
                        <div class="col-lg-6 wow fadeIn" data-wow-delay="0.5s">
                            <div class="mb-4">
                                <h1 class="mb-3">Contact With Our Certified Agent</h1>
                                <p>Eirmod sed ipsum dolor sit rebum magna erat. Tempor lorem kasd vero ipsum sit sit diam justo sed vero dolor duo.</p>
                            </div>
                            <a href="" class="btn btn-primary py-3 px-4 me-2"><i class="fa fa-phone-alt me-2"></i>Make A Call</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Call to Action End -->
    <!-- Team Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="text-center mx-auto mb-5 wow fadeInUp" data-wow-delay="0.1s" style="max-width: 600px;">
                <h1 class="mb-3">Property Agents</h1>
                <p>Eirmod sed ipsum dolor sit rebum labore magna erat. Tempor ut dolore lorem kasd vero ipsum sit eirmod sit. Ipsum diam justo sed rebum vero dolor duo.</p>
            </div>
            <div class="row g-4">
                <div class="col-lg-3 col-md-6 wow fadeInUp" data-wow-delay="0.1s">
                    <div class="team-item rounded overflow-hidden">
                        <div class="position-relative">
                            <img class="img-fluid" style="width: 300px; height: 300px; object-fit: cover" src="${pageContext.request.contextPath}/assets/img/team-11.jpg" alt="">
                            <div class="position-absolute start-50 top-100 translate-middle d-flex align-items-center">
                                <a class="btn btn-square mx-1" href="https://www.facebook.com/ndhieu1206/"><i class="fab fa-facebook-f"></i></a>
                            </div>
                        </div>
                        <div class="text-center p-4 mt-3">
                            <h5 class="fw-bold mb-0">Ngô Duy Hiếu</h5>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 wow fadeInUp" data-wow-delay="0.3s">
                    <div class="team-item rounded overflow-hidden">
                        <div class="position-relative">
                            <img class="img-fluid" style="width: 300px; height: 300px; object-fit: cover" src="${pageContext.request.contextPath}/assets/img/team-21.jpg" alt="">
                            <div class="position-absolute start-50 top-100 translate-middle d-flex align-items-center">
                                <a class="btn btn-square mx-1" href="https://www.facebook.com/thiepk1?mibextid=LQQJ4d" target="_blank"><i class="fab fa-facebook-f"></i></a>
                            </div>
                        </div>
                        <div class="text-center p-4 mt-3">
                            <h5 class="fw-bold mb-0">Khấu Trần Ngọc Thiệp</h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Team End -->
<%@ include file="views/master/foot.jsp" %>

