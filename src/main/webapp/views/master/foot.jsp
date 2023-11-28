<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Back to Top -->
<a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

<button id="trigger_modal" hidden="hidden" data-bs-toggle="modal" data-bs-target="#editModal" class="btn btn-danger">modal</button>
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel"><%= language.getProperty("location_choose_province") %></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="col-md-12">
                    <div class="form-group" id="asd">
                        <label for="province"><%=language.getProperty("location_choose_province")%></label>
                        <select v-on:change="check()" v-model="location" class="form-control" name="province" id="province">
                            <option value="0"><%=language.getProperty("location_choose_province")%></option>
                            <template v-for="(value, key) in provinces">
                                <option :value='"{\"id\": \""+value.id+"\", \"name\": \""+value.name+"\"}"'>{{value.name}}</option>
                            </template>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>


<!-- JavaScript Libraries -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/lib/wow/wow.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/lib/easing/easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/lib/waypoints/waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/lib/owlcarousel/owl.carousel.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.js"></script>
<!-- Template Javascript -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.5.1/axios.min.js" integrity="sha512-emSwuKiMyYedRwflbZB2ghzX8Cw8fmNVgZ6yQNNXXagFzFOaQmbvQ1vmDkddHjm5AITcBIZfC7k4ShQSjgPAmQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js" integrity="sha512-uKQ39gEGiyUJl4AI6L+ekBdGKpGw4xJ55+xyJG7YFlJokPNYegn9KwQ3P8A7aFQAUtUsAQHep+d/lrGqrbPIDQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" integrity="sha512-rMGGF4wg1R73ehtnxXBt5mbUfN9JUJwbk21KMlnLZDJh7BkPmeovBuddZCENJddHYYMkCh9hPFnPmS9sspki8g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.0/axios.min.js" integrity="sha512-WrdC3CE9vf1nBf58JHepuWT4x24uTacky9fuzw2g/3L9JkihgwZ6Cfv+JGTtNyosOhEmttMtEZ6H3qJWfI7gIQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
    const mess_error = "${error}"
    const mess_success = "${success}"
    const mess_warning = "${warning}"
    const info = "${info}"
    if (mess_error !== ""){
        toastr.error(mess_error, "<%= language.getProperty("error") %>")
    }
    if (mess_success !== ""){
        toastr.success(mess_success, "<%= language.getProperty("success") %>")
    }
    if (mess_warning !== ""){
        toastr.warning(mess_warning, "<%= language.getProperty("warning") %>")
    }
    if (info !== ""){
        toastr.info(info, "<%= language.getProperty("info") %>")
    }
</script>
<script>
    var choose_location_foot = new Vue({
        el: "#asd",
        data:{
            location: '0',
            provinces: [],
            test: 123,
        },
        created(){
            this.location = this.getCookie("location") == null ? '0' : this.getCookie("location")
            if (this.location == '0'){
                $("#trigger_modal").click()
                axios.get('<%=request.getContextPath()%>/api/get-locations')
                    .then((res)=>{
                        this.provinces = JSON.parse(res.data.provinces_list)
                    })
            } else {
                choose_location_head.updateCookie()
            }
        },
        methods:{
            getCookie(cookieName){
                const name = cookieName + "=";
                const decodedCookie = decodeURIComponent(document.cookie);
                const cookieArray = decodedCookie.split(';');

                for (let i = 0; i < cookieArray.length; i++) {
                    let cookie = cookieArray[i].trim();
                    if (cookie.indexOf(name) === 0) {
                        return cookie.substring(name.length, cookie.length);
                    }
                }
                return null;
            },
            setCookie(cname, cvalue, exdays) {
                const d = new Date();
                d.setTime(d.getTime() + (exdays*24*60*60*1000));
                let expires = "expires="+ d.toUTCString();
                document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
            },
            check(){
                if (this.location === '0'){
                    toastr.warning("<%=language.get("pls_choose_a_city")%>")
                } else {
                    this.setCookie('location', this.location, 100);
                    choose_location_head.updateCookie()
                }
            },
            show_modal(provinces) {
                this.provinces = provinces
                $("#trigger_modal").click()
            }
        }
    })
</script>
</script>
</body>

</html>