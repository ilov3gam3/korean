<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3">
    <h2 class="ml-5"><%=language.getProperty("admin.user_mana")%></h2>
    <table class="table table-bordered table-striped col-12" id="my_table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th><%=language.getProperty("admin.name")%></th>
            <th><%=language.getProperty("admin.email")%></th>
            <th><%=language.getProperty("admin.phone")%></th>
            <th><%=language.getProperty("admin.dob")%></th>
            <th><%=language.getProperty("admin.avatar")%></th>
            <th><%=language.getProperty("admin.is_verified_mail")%></th>
            <th class="col-1"><%=language.getProperty("admin.is_admin")%></th>
            <th><%=language.getProperty("admin.national_id")%></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${list}">
            <tr>
                <td>${item.getId()}</td>
                <td>${item.getName()}</td>
                <td>${item.getEmail()}</td>
                <td>${item.getPhone()}</td>
                <td>${item.getDob()}</td>
                <td>
                    <img src="${item.getAvatar()}" alt="user avatar" id="http_${item.getId()}"
                         style="width: 100px; height: 100px; object-fit: cover" onerror="document.getElementById('${item.getId()}').removeAttribute('hidden');document.getElementById('http_${item.getId()}').setAttribute('hidden', true)">
                    <img hidden="hidden" id="${item.getId()}" src="${pageContext.request.contextPath}${item.getAvatar()}" alt="user avatar"
                         style="width: 100px; height: 100px; object-fit: cover">
                </td>
                <c:choose>
                    <c:when test="${item.getIs_verified() == '1'}">
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/change-verify-email?id=${item.getId()}">
                                <button style="width: 100%" class="btn btn-success"><%=language.getProperty("admin.yes")%></button>
                            </a>
                        </td>
                    </c:when>
                    <c:otherwise>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/change-verify-email?id=${item.getId()}">
                                <button style="width: 100%" class="btn btn-danger"><%=language.getProperty("admin.no")%></button>
                            </a>
                        </td>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${item.getIs_admin() == '1'}">
                        <td class="col-1">
                            <a href="${pageContext.request.contextPath}/admin/change-admin?id=${item.getId()}">
                                <button style="width: 100%" class="btn btn-success"><%=language.getProperty("admin.yes")%></button>
                            </a>
                        </td>
                    </c:when>
                    <c:otherwise>
                        <td class="col-1">
                            <a href="${pageContext.request.contextPath}/admin/change-admin?id=${item.getId()}">
                                <button style="width: 100%" class="btn btn-danger"><%=language.getProperty("admin.no")%></button>
                            </a>
                        </td>
                    </c:otherwise>
                </c:choose>
                <td>
                    <div class="col-md-12 text-center">
                            ${item.getNational_id()}
                    </div>
                    <div class="col-md-12 text-center">
                        <button class="btn btn-${item.getCards_verified() == 1 ? 'primary' : 'danger'}"
                                onclick="show_cards('${item.getFront_id_card()}', '${item.getBack_id_card()}', '${item.getNational_id()}', '${item.getCards_verified()}')"
                                style="width: 100%;"><%=language.getProperty("admin.view_cards")%>
                        </button>
                        <button onclick="showEditModal('${item.getId()}', '${item.getName()}', '${item.getEmail()}', '${item.getPhone()}', '${item.getNationality()}', '${item.getDob()}')" class="btn btn-warning mt-2" style="width: 100%;" type="button" data-bs-toggle="modal" data-bs-target="#editModal">
                            <%=language.getProperty("amenities_edit")%>
                        </button>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<!-- Modal -->
<div class="modal fade" id="card_modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/admin/change-verified-card" method="post" >
                <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="national_id"><%=language.getProperty("admin.national_id")%></label>
                                <input class="form-control" type="text" name="national_id" id="national_id">
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div class="form-group" style="width: 100%">
                                <label id="info_cards_verified"></label>
                                <button type="submit" class="btn btn-primary" style="width: 100%" id="btn_verified" value="verified" name="status" hidden><%=language.getProperty("admin.confirm")%></button>
                                <button type="submit" class="btn btn-danger" style="width: 100%" id="btn_remove_verified" value="un_verified" name="status" hidden><%=language.getProperty("admin.un_confirm")%></button>
                            </div>
                        </div>
                </div>
                </form>
                <div class="row">
                    <div class="col-md-6">
                        <p><%=language.getProperty("admin.front")%></p>
                        <img src="" alt="" style="width: 100%;" id="front">
                        <p class="text-danger" hidden id="no_front"><%=language.getProperty("admin.no_front")%></p>
                    </div>
                    <div class="col-md-6">
                        <p><%=language.getProperty("admin.back")%></p>
                        <img src="" alt="" style="width: 100%;" id="back">
                        <p class="text-danger" hidden id="no_back"><%=language.getProperty("admin.no_back")%></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" >Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/admin/update-user" method="post" >
                    <input type="hidden" name="id" id="id">
                    <div class="row col-12">
                        <div class="form-group">
                            <label for="update_name"><%= language.getProperty("register.name.label") %></label>
                            <input type="text" class="form-control" name="update_name" id="update_name">
                        </div>
                        <div class="form-group">
                            <label for="update_email"><%= language.getProperty("register.email.label") %></label>
                            <input type="email" class="form-control" name="update_email" id="update_email">
                        </div>
                        <div class="form-group">
                            <label for="update_phone"><%= language.getProperty("register.phone.label") %></label>
                            <input type="text" class="form-control" name="update_phone" id="update_phone">
                        </div>
                        <div class="form-group">
                            <label for="update_nationality"><%= language.getProperty("register.nationality.label") %></label>
                            <select id="update_nationality" name="update_nationality" data-placeholder="Choose a Country..." class="chosen-select form-control chosen">
                                <option value=""></option>
                                <option value="United States">United States</option>
                                <option value="United Kingdom">United Kingdom</option>
                                <option value="Afghanistan">Afghanistan</option>
                                <option value="Aland Islands">Aland Islands</option>
                                <option value="Albania">Albania</option>
                                <option value="Algeria">Algeria</option>
                                <option value="American Samoa">American Samoa</option>
                                <option value="Andorra">Andorra</option>
                                <option value="Angola">Angola</option>
                                <option value="Anguilla">Anguilla</option>
                                <option value="Antarctica">Antarctica</option>
                                <option value="Antigua and Barbuda">Antigua and Barbuda</option>
                                <option value="Argentina">Argentina</option>
                                <option value="Armenia">Armenia</option>
                                <option value="Aruba">Aruba</option>
                                <option value="Australia">Australia</option>
                                <option value="Austria">Austria</option>
                                <option value="Azerbaijan">Azerbaijan</option>
                                <option value="Bahamas">Bahamas</option>
                                <option value="Bahrain">Bahrain</option>
                                <option value="Bangladesh">Bangladesh</option>
                                <option value="Barbados">Barbados</option>
                                <option value="Belarus">Belarus</option>
                                <option value="Belgium">Belgium</option>
                                <option value="Belize">Belize</option>
                                <option value="Benin">Benin</option>
                                <option value="Bermuda">Bermuda</option>
                                <option value="Bhutan">Bhutan</option>
                                <option value="Bolivia, Plurinational State of">Bolivia, Plurinational State of</option>
                                <option value="Bonaire, Sint Eustatius and Saba">Bonaire, Sint Eustatius and Saba</option>
                                <option value="Bosnia and Herzegovina">Bosnia and Herzegovina</option>
                                <option value="Botswana">Botswana</option>
                                <option value="Bouvet Island">Bouvet Island</option>
                                <option value="Brazil">Brazil</option>
                                <option value="British Indian Ocean Territory">British Indian Ocean Territory</option>
                                <option value="Brunei Darussalam">Brunei Darussalam</option>
                                <option value="Bulgaria">Bulgaria</option>
                                <option value="Burkina Faso">Burkina Faso</option>
                                <option value="Burundi">Burundi</option>
                                <option value="Cambodia">Cambodia</option>
                                <option value="Cameroon">Cameroon</option>
                                <option value="Canada">Canada</option>
                                <option value="Cape Verde">Cape Verde</option>
                                <option value="Cayman Islands">Cayman Islands</option>
                                <option value="Central African Republic">Central African Republic</option>
                                <option value="Chad">Chad</option>
                                <option value="Chile">Chile</option>
                                <option value="China">China</option>
                                <option value="Christmas Island">Christmas Island</option>
                                <option value="Cocos (Keeling) Islands">Cocos (Keeling) Islands</option>
                                <option value="Colombia">Colombia</option>
                                <option value="Comoros">Comoros</option>
                                <option value="Congo">Congo</option>
                                <option value="Congo, The Democratic Republic of The">Congo, The Democratic Republic of The</option>
                                <option value="Cook Islands">Cook Islands</option>
                                <option value="Costa Rica">Costa Rica</option>
                                <option value="Cote D&apos;ivoire">Cote D'ivoire</option>
                                <option value="Croatia">Croatia</option>
                                <option value="Cuba">Cuba</option>
                                <option value="Curacao">Curacao</option>
                                <option value="Cyprus">Cyprus</option>
                                <option value="Czech Republic">Czech Republic</option>
                                <option value="Denmark">Denmark</option>
                                <option value="Djibouti">Djibouti</option>
                                <option value="Dominica">Dominica</option>
                                <option value="Dominican Republic">Dominican Republic</option>
                                <option value="Ecuador">Ecuador</option>
                                <option value="Egypt">Egypt</option>
                                <option value="El Salvador">El Salvador</option>
                                <option value="Equatorial Guinea">Equatorial Guinea</option>
                                <option value="Eritrea">Eritrea</option>
                                <option value="Estonia">Estonia</option>
                                <option value="Ethiopia">Ethiopia</option>
                                <option value="Falkland Islands (Malvinas)">Falkland Islands (Malvinas)</option>
                                <option value="Faroe Islands">Faroe Islands</option>
                                <option value="Fiji">Fiji</option>
                                <option value="Finland">Finland</option>
                                <option value="France">France</option>
                                <option value="French Guiana">French Guiana</option>
                                <option value="French Polynesia">French Polynesia</option>
                                <option value="French Southern Territories">French Southern Territories</option>
                                <option value="Gabon">Gabon</option>
                                <option value="Gambia">Gambia</option>
                                <option value="Georgia">Georgia</option>
                                <option value="Germany">Germany</option>
                                <option value="Ghana">Ghana</option>
                                <option value="Gibraltar">Gibraltar</option>
                                <option value="Greece">Greece</option>
                                <option value="Greenland">Greenland</option>
                                <option value="Grenada">Grenada</option>
                                <option value="Guadeloupe">Guadeloupe</option>
                                <option value="Guam">Guam</option>
                                <option value="Guatemala">Guatemala</option>
                                <option value="Guernsey">Guernsey</option>
                                <option value="Guinea">Guinea</option>
                                <option value="Guinea-bissau">Guinea-bissau</option>
                                <option value="Guyana">Guyana</option>
                                <option value="Haiti">Haiti</option>
                                <option value="Heard Island and Mcdonald Islands">Heard Island and Mcdonald Islands</option>
                                <option value="Holy See (Vatican City State)">Holy See (Vatican City State)</option>
                                <option value="Honduras">Honduras</option>
                                <option value="Hong Kong">Hong Kong</option>
                                <option value="Hungary">Hungary</option>
                                <option value="Iceland">Iceland</option>
                                <option value="India">India</option>
                                <option value="Indonesia">Indonesia</option>
                                <option value="Iran, Islamic Republic of">Iran, Islamic Republic of</option>
                                <option value="Iraq">Iraq</option>
                                <option value="Ireland">Ireland</option>
                                <option value="Isle of Man">Isle of Man</option>
                                <option value="Israel">Israel</option>
                                <option value="Italy">Italy</option>
                                <option value="Jamaica">Jamaica</option>
                                <option value="Japan">Japan</option>
                                <option value="Jersey">Jersey</option>
                                <option value="Jordan">Jordan</option>
                                <option value="Kazakhstan">Kazakhstan</option>
                                <option value="Kenya">Kenya</option>
                                <option value="Kiribati">Kiribati</option>
                                <option value="Korea, Democratic People&apos;s Republic of">Korea, Democratic People's Republic of</option>
                                <option value="Korea, Republic of">Korea, Republic of</option>
                                <option value="Kuwait">Kuwait</option>
                                <option value="Kyrgyzstan">Kyrgyzstan</option>
                                <option value="Lao People&apos;s Democratic Republic">Lao People's Democratic Republic</option>
                                <option value="Latvia">Latvia</option>
                                <option value="Lebanon">Lebanon</option>
                                <option value="Lesotho">Lesotho</option>
                                <option value="Liberia">Liberia</option>
                                <option value="Libya">Libya</option>
                                <option value="Liechtenstein">Liechtenstein</option>
                                <option value="Lithuania">Lithuania</option>
                                <option value="Luxembourg">Luxembourg</option>
                                <option value="Macao">Macao</option>
                                <option value="Macedonia, The Former Yugoslav Republic of">Macedonia, The Former Yugoslav Republic of</option>
                                <option value="Madagascar">Madagascar</option>
                                <option value="Malawi">Malawi</option>
                                <option value="Malaysia">Malaysia</option>
                                <option value="Maldives">Maldives</option>
                                <option value="Mali">Mali</option>
                                <option value="Malta">Malta</option>
                                <option value="Marshall Islands">Marshall Islands</option>
                                <option value="Martinique">Martinique</option>
                                <option value="Mauritania">Mauritania</option>
                                <option value="Mauritius">Mauritius</option>
                                <option value="Mayotte">Mayotte</option>
                                <option value="Mexico">Mexico</option>
                                <option value="Micronesia, Federated States of">Micronesia, Federated States of</option>
                                <option value="Moldova, Republic of">Moldova, Republic of</option>
                                <option value="Monaco">Monaco</option>
                                <option value="Mongolia">Mongolia</option>
                                <option value="Montenegro">Montenegro</option>
                                <option value="Montserrat">Montserrat</option>
                                <option value="Morocco">Morocco</option>
                                <option value="Mozambique">Mozambique</option>
                                <option value="Myanmar">Myanmar</option>
                                <option value="Namibia">Namibia</option>
                                <option value="Nauru">Nauru</option>
                                <option value="Nepal">Nepal</option>
                                <option value="Netherlands">Netherlands</option>
                                <option value="New Caledonia">New Caledonia</option>
                                <option value="New Zealand">New Zealand</option>
                                <option value="Nicaragua">Nicaragua</option>
                                <option value="Niger">Niger</option>
                                <option value="Nigeria">Nigeria</option>
                                <option value="Niue">Niue</option>
                                <option value="Norfolk Island">Norfolk Island</option>
                                <option value="Northern Mariana Islands">Northern Mariana Islands</option>
                                <option value="Norway">Norway</option>
                                <option value="Oman">Oman</option>
                                <option value="Pakistan">Pakistan</option>
                                <option value="Palau">Palau</option>
                                <option value="Palestinian Territory, Occupied">Palestinian Territory, Occupied</option>
                                <option value="Panama">Panama</option>
                                <option value="Papua New Guinea">Papua New Guinea</option>
                                <option value="Paraguay">Paraguay</option>
                                <option value="Peru">Peru</option>
                                <option value="Philippines">Philippines</option>
                                <option value="Pitcairn">Pitcairn</option>
                                <option value="Poland">Poland</option>
                                <option value="Portugal">Portugal</option>
                                <option value="Puerto Rico">Puerto Rico</option>
                                <option value="Qatar">Qatar</option>
                                <option value="Reunion">Reunion</option>
                                <option value="Romania">Romania</option>
                                <option value="Russian Federation">Russian Federation</option>
                                <option value="Rwanda">Rwanda</option>
                                <option value="Saint Barthelemy">Saint Barthelemy</option>
                                <option value="Saint Helena, Ascension and Tristan da Cunha">Saint Helena, Ascension and Tristan da Cunha</option>
                                <option value="Saint Kitts and Nevis">Saint Kitts and Nevis</option>
                                <option value="Saint Lucia">Saint Lucia</option>
                                <option value="Saint Martin (French part)">Saint Martin (French part)</option>
                                <option value="Saint Pierre and Miquelon">Saint Pierre and Miquelon</option>
                                <option value="Saint Vincent and The Grenadines">Saint Vincent and The Grenadines</option>
                                <option value="Samoa">Samoa</option>
                                <option value="San Marino">San Marino</option>
                                <option value="Sao Tome and Principe">Sao Tome and Principe</option>
                                <option value="Saudi Arabia">Saudi Arabia</option>
                                <option value="Senegal">Senegal</option>
                                <option value="Serbia">Serbia</option>
                                <option value="Seychelles">Seychelles</option>
                                <option value="Sierra Leone">Sierra Leone</option>
                                <option value="Singapore">Singapore</option>
                                <option value="Sint Maarten (Dutch part)">Sint Maarten (Dutch part)</option>
                                <option value="Slovakia">Slovakia</option>
                                <option value="Slovenia">Slovenia</option>
                                <option value="Solomon Islands">Solomon Islands</option>
                                <option value="Somalia">Somalia</option>
                                <option value="South Africa">South Africa</option>
                                <option value="South Georgia and The South Sandwich Islands">South Georgia and The South Sandwich Islands</option>
                                <option value="South Sudan">South Sudan</option>
                                <option value="Spain">Spain</option>
                                <option value="Sri Lanka">Sri Lanka</option>
                                <option value="Sudan">Sudan</option>
                                <option value="Suriname">Suriname</option>
                                <option value="Svalbard and Jan Mayen">Svalbard and Jan Mayen</option>
                                <option value="Swaziland">Swaziland</option>
                                <option value="Sweden">Sweden</option>
                                <option value="Switzerland">Switzerland</option>
                                <option value="Syrian Arab Republic">Syrian Arab Republic</option>
                                <option value="Taiwan, Province of China">Taiwan, Province of China</option>
                                <option value="Tajikistan">Tajikistan</option>
                                <option value="Tanzania, United Republic of">Tanzania, United Republic of</option>
                                <option value="Thailand">Thailand</option>
                                <option value="Timor-leste">Timor-leste</option>
                                <option value="Togo">Togo</option>
                                <option value="Tokelau">Tokelau</option>
                                <option value="Tonga">Tonga</option>
                                <option value="Trinidad and Tobago">Trinidad and Tobago</option>
                                <option value="Tunisia">Tunisia</option>
                                <option value="Turkey">Turkey</option>
                                <option value="Turkmenistan">Turkmenistan</option>
                                <option value="Turks and Caicos Islands">Turks and Caicos Islands</option>
                                <option value="Tuvalu">Tuvalu</option>
                                <option value="Uganda">Uganda</option>
                                <option value="Ukraine">Ukraine</option>
                                <option value="United Arab Emirates">United Arab Emirates</option>
                                <option value="United Kingdom">United Kingdom</option>
                                <option value="United States">United States</option>
                                <option value="United States Minor Outlying Islands">United States Minor Outlying Islands</option>
                                <option value="Uruguay">Uruguay</option>
                                <option value="Uzbekistan">Uzbekistan</option>
                                <option value="Vanuatu">Vanuatu</option>
                                <option value="Venezuela, Bolivarian Republic of">Venezuela, Bolivarian Republic of</option>
                                <option value="Viet Nam">Viet Nam</option>
                                <option value="Virgin Islands, British">Virgin Islands, British</option>
                                <option value="Virgin Islands, U.S.">Virgin Islands, U.S.</option>
                                <option value="Wallis and Futuna">Wallis and Futuna</option>
                                <option value="Western Sahara">Western Sahara</option>
                                <option value="Yemen">Yemen</option>
                                <option value="Zambia">Zambia</option>
                                <option value="Zimbabwe">Zimbabwe</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="update_dob"><%= language.getProperty("register.dob.label") %></label>
                            <input type="date" class="form-control" name="update_dob" id="update_dob">
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary" style="width: 100%">
                                <%=language.getProperty("amenities_edit")%>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
    var myModal = new bootstrap.Modal(document.getElementById("card_modal"))
    let table = new DataTable('#my_table');
    function show_cards(front, back, id, card_verified) {
        if (card_verified === '1'){
            $("#info_cards_verified").text("<%=language.getProperty("admin.national_id_verified")%>")
            $("#info_cards_verified").attr('class', 'text-primary')
            $("#btn_remove_verified").removeAttr('hidden')
        }
        if (card_verified === '0'){
            $("#info_cards_verified").text("<%=language.getProperty("admin.national_id_un_verified")%>")
            $("#info_cards_verified").attr('class', 'text-danger')
            $("#btn_verified").removeAttr('hidden')
        }
        $("#national_id").val(id);
        $("#front").attr('src', front)
        $("#back").attr('src', back)
        if (front === ''){
            $("#no_front").removeAttr('hidden')
        }
        if (back === ''){
            $("#no_back").removeAttr('hidden')
        }
        myModal.show()
    }
    $("#card_modal").on("hidden.bs.modal", function () {
        $("#no_front").attr('hidden', true)
        $("#no_back").attr('hidden', true)
        $("#front").attr('src', '')
        $("#back").attr('src', '')
        $("#national_id").val('');
        $("#btn_remove_verified").attr('hidden', true)
        $("#btn_verified").attr('hidden', true)
    });
    var editModal = $("#editModal")
    editModal.on('show.bs.modal', function () {
        $("#navbar").attr("hidden", true)
    })
    editModal.on('hidden.bs.modal', function () {
        $("#navbar").attr("hidden", false)
    })
    function showEditModal(id, name, email, phone, nationality, dob) {
        $("#update_name").val(name)
        $("#update_email").val(email)
        $("#update_phone").val(phone)
        $("#update_nationality").val(nationality);
        $("#update_dob").val(dob)
        $("#id").val(id)
    }
</script>