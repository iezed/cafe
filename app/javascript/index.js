
function display_gender(gender)
{
    if(gender==null) {
        return '미입력';
    }

    if (gender==1) {
        return '남자';
    } else {
        return '여자';
    }
}

function setDateInput(obj) {
    if (obj != undefined) {
        var datediff = -(parseInt(obj));
        var newDate = new Date();
        var now = new Date();
        newDate.setDate(now.getDate()+datediff);
        var newYear = newDate.getFullYear();
        var newMonth = newDate.getMonth()+1;
        if (newMonth.toString().length == 1) newMonth = "0" + newMonth;

        endMonth=now.getMonth() +1;
        if (endMonth.toString().length == 1) endMonth = "0" + endMonth;

        var newDay = newDate.getDate();
        if (newDay.toString().length == 1) { newDay = "0" + newDay};

        var txtSDate = newYear + "-" + newMonth +'-'+ newDay;
        endDay=now.getDate();

        if (endDay.toString().length == 1) {endDay = "0" + endDay; };
        var txtEDate = now.getFullYear() + '-' + endMonth + "-" + endDay;

        $('input[name="start_date"]').val(txtSDate).effect("highlight");
        $('input[name="end_date"]').val(txtEDate).effect("highlight");
    } else {alert("잠시 후 이용해 주시기 바랍니다."); return false;}
}

function stripComma(str) {
    var re = /,/g;
    return str.replace(re, "");
}

function add_hyphen(v) {
    if( !v ){
        return v;
    }

    v = v.replace(/[^0-9]/g, '');
    return v.replace(/^(0(?:2|[0-9]{2}))([0-9]+)([0-9]{4}$)/, "$1-$2-$3");
}

function initPagination(num_entries, items_per_page, current_page) {
    if(!current_page) {
        var current_page=0;
    }

    if(num_entries<=items_per_page) {
        return false;
    }

    $(".sl_pagination").pagination(num_entries, {
        current_page : current_page,
        num_edge_entries : 2,
        num_display_entries : 8,
        callback : pageselectCallback,
        items_per_page : items_per_page
    });
    return false;
}

function pageselectCallback(page_index, jq) {
    if ($(jq).data("load") == true)
        getList(page_index, jq);
    else
        $(jq).data("load", true);

    return false;
}


var current_page=0;

function getList(current_page, jq) {
    if(!current_page)
        current_page = 0;

    var perPage =10;
    var pageID=current_page+1;

    var searchType=null;
    var searchField=null;
    var searchWord=null;

    if($.trim($("#search-word").val())!='') {
        searchField=$('input[name="search_type"]:checked').val();
        searchWord=$.trim($("#search-word").val());
    }

    $.getJSON('/admin/users.json',{'search_field':searchField,'search_word':searchWord,'per_page':perPage,'page':pageID},function(data) {
        $("#user-select-list tbody").empty();
        $('#user-select-list_count').val(data.total);

        if(data.length==1) {
            $.each(data,function(index,value){
                if(value.left_coupon) {
                    var left_coupon=value.left_coupon;
                } else {
                    var left_coupon=0;
                }

                $("#user-select-list tbody").append('<tr>'+input+'<td class="name">'+value['name']+'</td><td class="phone">'+add_hyphen(value['phone'])+'</td></tr>');
            });

            $('#user-select-list tbody td').click(m_td_click);
            $('#user-select-list tbody tr td input').click(function(e) {
                e.stopPropagation();
            }).change(function(){
                var tr=$(this).closest('tr');
                var u_id=tr.find('td:first input').val();
                var u_name=tr.find('td:eq(1)').text();
                var u_phone=tr.find('td:eq(3)').text();
                var left_coupon=tr.find('td input:eq(1)').val();
                var black_list_exists= tr.find('td input:eq(2)').val();
                var black_list= tr.find('td input:eq(3)').val();

                var content={'id':u_id,'name':u_name,'left_coupon':left_coupon,'phone':u_phone,'black_list_exists':black_list_exists,'black_list':black_list};
                select_user(content);
            });
        } else {
            $("#user-select-list tbody").append('<tr><td colspan="4" style="text-align:center">해당 데이터가 없습니다.</td></tr>');
        }
        $(".sl_pagination").removeData("load").empty();
        initPagination(data.length,10,current_page);
    });
}


function m_td_click() {
    var i_checkbox = $(this).parent().find('input:first').prop('checked',true).change();
}

function select_user(content) {
    $("#order-user-id").val(content.id);
    $("#user-info").show();
    $("#user-search").hide();

    var user_name=content.name;

    if($("#display_coupon").val()==1) {
        user_name+= '<br />('+content.left_coupon+'회 남음)<input type="hidden" id="left_coupon" value="'+content.left_coupon+'">';
    }

    $("#user_name").html(user_name);
    /* '<br />('+content.level_name+')<input type="hidden" id="dc_rate" value="'+content.dc_rate+'" />'); */

    if(content.phone) {
        var phone=content.phone;
    } else {
        var phone='미입력';
    }
    $("#user_phone").text(phone);

    if(content.black_list_exists>0) {
        $("#user-search-form .card").addClass('border-warning');

        var card_footer=$('<div>');
        card_footer.addClass('card-footer bg-warning border-warning');
        card_footer.html('<span class="text text-white">'+content.black_list+'</span>');

        $("#user-search-form .card").append(card_footer);
    } else {
        if($("#user-search-form .card").hasClass('border-warning')) {
            $("#user-search-form .card").removeClass('border-warning');
        }
    }

    if($("#order_complete").length) {
        if(phone!='미입력') {
            $('#order_form input[name="CashNumber"]').val(phone.replace(/-/g, ""));
        }
    }
}

var ready=function(){
    var product_category_id;
    var no_exists_order_t=$('#no_data_t').val();
    $('#order_form .delete').click(delete_order);
    $('#order_form .plus').click(plus_click);
    $('#order_form .minus').click(minus_click);

    $('input[name="search_field"]').change(function() {
        $("#search_label").text($(this).parent().find('label').text());
        $("#search-word").val('');
        $("#search-word").focus();
    });

    $('.product-category-link').click(function(event){
        event.preventDefault();
        product_category_id=$(this).attr('href').split('?product_category_id=')[1];

        $('.product-category-link').removeClass('active');
        $(this).addClass('active');

        getProductList();
    });

    function getProductList(current_page, jq) {
        if(!current_page)
            current_page = 0;

        var perPage =10;
        var pageID=current_page+1;

        $.getJSON('/products.json',{product_category_id: product_category_id, 'per_page':perPage,'page':pageID},function(data) {
            var product=$("#order-product-list article:first").clone(true);

            $("#order-product-list").empty();
            $.each(data,function(index,value) {
                var product_c=product.clone(true);

                var exists_product=check_exists_product(value.id);

                product_c.find('.card-header span:first').text(value.title);
                product_c.find('.card-header i').data('info','/products/'+value.id);
                product_c.find('input:first').val(value.id);
                product_c.find('input:eq(1)').val(value.price);
                product_c.find('p:first').text(value.price.toLocaleString( 'ko-KR',{style:"currency", currency:"KRW"}));

                if(value.product_pictures_count>0) {
                    product_c.find('.product-pictures').empty();
                    product_c.find('.product-pictures').append('<img src="'+value.product_pictures[0].picture.medium_thumb.url +'">');
                } else {
                    product_c.find('.product-pictures').empty();
                }

                if(exists_product) {
                    product_c.find('.quantity').val(exists_product.find('.quantity-l input:first').val());
                } else {
                    product_c.find('.quantity').val(0);
                }

                $("#order-product-list").append(product_c);
            });

            //$(".sl_pagination").removeData("load").empty();
            // initPagination(data.length,10,current_page);
        });
    }

    function delete_order(event,ele){
        var tr = $(this).closest('tr');

        if(ele) {
            tr = ele;
        }

        var product_id=tr.find('input:first').val();
        var product_ele=$('#order-product-list article input[name="product_id[]"][value="'+product_id+'"]');

        if(product_ele) {
            product_ele.closest('.card').find('.quantity').val(0);
        }

        tr.remove();
        make_order();
    }

    function plus_click(event){
        var tr=$(this).closest('tr');
        var product_id=tr.find('input:first').val();
        var product_ele=$('#order-product-list article input[name="product_id[]"][value="'+product_id+'"]');

        var plus_value  = Number(tr.find('.quantity-l input:first').val())+1;

        tr.find('.quantity-l input:first').val(plus_value);
        tr.find('.quantity').text(plus_value);

        if(product_ele) {
            var ele = product_ele.closest('.card').find('.quantity');
            ele.val(plus_value);
        }

        make_order();
    }

    function minus_click(event){
        var tr=$(this).closest('tr');
        var product_id=tr.find('input:first').val();
        var product_ele=$('#order-product-list article input[name="product_id[]"][value="'+product_id+'"]');


        var minus_value=Number(tr.find('.quantity-l input:first').val())-1;

        tr.find('.quantity-l input:first').val(minus_value);
        tr.find('.quantity').text(minus_value);

        if(product_ele) {
            var ele = product_ele.closest('.card').find('.quantity');
            ele.val(minus_value);
        }

        if(minus_value==0) {
            delete_order(event,tr);
        }

        make_order();
    }

    function check_exists_product(product_id) {
        var product_exists = false;

        $("#order_form tbody tr").each(function(){
            if(product_id==Number($(this).find('input:first').val())) {
                product_exists=$(this);
                return true;
            }
        });

        return product_exists;
    }

    function make_order(){
        if($("#order_form tbody .no_data").length) {
            $("#order_form tbody tr").remove();
        }

        $("#order-new .list article .card").each(function(){
            var quantity = $(this).find('input.quantity').val();
            var exists_tr=false;

            if(quantity==0) {
                return true;
            }

            var product_id = Number($(this).find('input[name="product_id[]"]').val());

            exists_tr=check_exists_product(product_id);

            var price = $(this).find('input[name="price[]"]').val();
            var dc_rate = 0;
            var last_price = Number(quantity * (price - (price * (dc_rate / 100))));

            if(exists_tr) {
                exists_tr.find('.quantity-l input:first').val(quantity);
                exists_tr.find('.quantity').text(quantity);
                //exists_tr.find('td')

                exists_tr.find('.price input:first').val(last_price);
                exists_tr.find('.price_t').text(last_price.toLocaleString( 'ko-KR',{style:"currency", currency:"KRW"}));
            } else {
                var title = $(this).find('.card-header span:first').text();
                var tr = $('<tr class="order"><td><input type="hidden" name="order[order_products_attributes]['+product_id+'][product_id]" value="' + product_id + '">' + title + '</td><td class="price text-right"><input type="hidden" value="' + last_price + '"><span class="price_t">' + last_price.toLocaleString( 'ko-KR',{style:"currency", currency:"KRW"}) + '</span></td><td class="text-center quantity-l"><span class="btn btn-success plus">+</span>&nbsp;<input type="hidden" name="order[order_products_attributes]['+product_id+'][quantity]" value="' + quantity + '"><span class="quantity">' + quantity + '</span>&nbsp;<span class="btn btn-warning minus">-</span></td><td class="text-center"><span class="btn btn-danger delete">' + $('#cancel_s').text() + '</span></td></tr>');
                tr.find('.delete').click(delete_order);
                tr.find('.plus').click(plus_click);
                tr.find('.minus').click(minus_click);

                $("#order_form tbody").append(tr);
                tr.find('td').effect('highlight',1000);
            }
        });


        var total_quantity=new Array();
        var total_price=new Array();

        $("#order_form tbody tr").each(function(){
            var price=$(this).find('.price input:first').val();
            var quantity=$(this).find('.quantity-l input:first').val();

            total_quantity.push(quantity)
            total_price.push(price);
        });

        var total_result_price=total_price.reduce((a, b) => Number(a) + Number(b), 0);

        $('#total-price').text(Number(total_result_price).toLocaleString( 'ko-KR',{style:"currency", currency:"KRW"}));

        if($('#order_form table tbody tr.order').length) {
            $('#select-complete').removeClass('disabled');
        } else {
            $('#select-complete').addClass('disabled');
            $('#order_form tbody').append('<tr><td colspan="4" class="text-center no_data">'+no_exists_order_t+'</td></tr>');
        }
    }


    $("#order-new .list article .card input.quantity").change(function(event){
        if($(this).val()==0) {
            var ele=check_exists_product($(this).closest('.card').find('input:first').val());
            delete_order(event,ele);
        }
        make_order();
    });
    $("#order-new .list article .card-header,#order-new .list article .card-body").click(function () {
        $(this).closest('.card').find('input.quantity').val(Number($(this).closest('.card').find('input.quantity').val())+1).change();
    }).css('cursor','pointer');

    $("#order-new .list article .card-header i").click(function(event){
        event.stopPropagation();

        $('#myModal').removeData("modal");
        var url = $(this).data('info') + '?popup=true';

        $('#myModal').load(url, function () {
            var myModal = document.getElementById('myModal');
            var modal = bootstrap.Modal.getOrCreateInstance(myModal)
            modal.show();
        });
    }).css('cursor','help');



    // 자바스크립트가 지원될때 Tr 커서 선택
    $("#user-select-list tbody tr,#order_add article .card").css('cursor','pointer');
    $('#user-select-list tbody td').click(m_td_click);

    $('#user-select-list tbody tr td input').change(function(){
        var tr=$(this).closest('tr');
        var u_id=tr.find('td:first input').val();
        var u_name=tr.find('td:eq(1)').text();
        var u_phone=tr.find('td:eq(2)').text();
        var left_coupon=tr.find('td input:eq(1)').val();
        var black_list_exists=tr.find('td input:eq(3)').val();
        var black_list=tr.find('td input:eq(4)').val();

        var content={'id':u_id,'name':u_name,'left_coupon':left_coupon,'phone':u_phone, 'black_list_exists':black_list_exists,'black_list':black_list};
        select_user(content);
    });
    initPagination(Number($('#user-select-list-count').val()),10,0);

    $("#user_select_cancel").click(function(){
        $("#user-info").hide();
        $("#user-search").show();
        $("#order-user-id").val('');

        if($(this).closest('.card').hasClass('border-warning')) {
            $(this).closest('.card').removeClass('border-warning');
            $(this).closest('.card').find('.card-footer').remove();
        }
    });

    $('input[name="search_field"]').change(function(){
        $("#search_label").text($(this).parent().find('label').text());
    });

    $('input[name="search_field"]').each(function(){
        if($(this).is(":checked")) {
            $("#search_label").text($(this).parent().find('label').text());
        }
    });

    $("#user-search-form").submit(function(){
        var search_field=$(this).find('input[name="search_field"]:checked').val();
        var search_word=$(this).find('#search-word').val();

        $.getJSON('/admin/users.json',{'search_field' : search_field,'search_word' : search_word,'per_page':10,'page':1},function(data){
            if(data.length==1) {
                $("#user-select-list").hide();
                var content=data[0];

                select_user(content);

                $("#user-search-form h3 span:first").hide();
                $("#user-search-form h3 span:eq(1)").show();
            } else {
                if(data.length) {
                    $("#user-select-list").show();
                    $("#user-select-list tbody").empty();
                    $('#user-select-list_count').val(data.total);

                    $.each(data,function(index,value){

                        if(value.left_coupon) {
                            var left_coupon=value.left_coupon;
                        } else {
                            var left_coupon=0;
                        }

                        var input='<td class="text-center"><input name="id" value="'+value.id+'" type="radio"><input type="hidden" value="'+left_coupon+'"><input type="hidden" value="'+value.black_list_exists+'"><input type="hidden" value="'+value.black_list+'"></td>';

                        $("#user-select-list tbody").append('<tr>'+input+'<td class="name">'+value['name']+'</td><td class="phone">'+add_hyphen(value['phone'])+'</td></tr>');
                    });

                    $('#user-select-list tbody td').click(m_td_click);
                    $('#user-select-list tbody tr td input').click(function(e) {
                        e.stopPropagation();
                    }).change(function(){
                        var tr=$(this).closest('tr');
                        var u_id=tr.find('td:first input').val();
                        var u_name=tr.find('td:eq(1)').text();
                        var u_phone=tr.find('td:eq(2)').text();
                        var left_coupon=tr.find('td input:eq(1)').val();
                        var black_list_exists=tr.find('td input:eq(3)').val();
                        var black_list=tr.find('td input:eq(4)').val();

                        var content={'id':u_id,'name':u_name,'left_coupon':left_coupon,'phone':u_phone,'black_list_exists':black_list_exists,'black_list':black_list};
                        select_user(content);
                    });
                } else {
                    $("#user-select-list").show();
                    $("#user-select-list tbody").empty();
                    $("#user-select-list tbody").append('<tr><td colspan="4" style="text-align:center">해당 데이터가 없습니다.</td></tr>');
                }
                $(".sl_pagination").removeData("load").empty();
                initPagination(data.total,10,current_page);
            }
        });

        return false;
    });

    $("#select-complete").click(function(){
        if($(this).hasClass('disabled')) {
            alert($("#select_first_text").val());
            return false;
        }
        $('.order-layer').hide();
        $('.payment-layer').show();
    });

    $("#select-again").click(function() {
        $('.order-layer').show();
        $('.payment-layer').hide();
    });

    $("#cancel_all").click(function(){
        $("#order-new .list article .card input.quantity").val(0);

        $("#order_form tbody").empty();
        var no_eo_tr=$('<tr><td colspan="4" class="text-center no_data">'+no_exists_order_t+'</td></tr>');
        $("#order_form tbody").append(no_eo_tr);

        make_order();
    });

    $('input[name="locale"]').change(function(){
        $('#order-new input[type="submit"]').val($(this).closest('label').find('input:first').val());
        $("#order-new h1").text($(this).closest('label').find('input:eq(1)').val());
    });

    $("#anon").change(function(){
        if($(this).is(":checked")) {
            $("#order-user-id").val($("#anon_id").val());
            $(".non-anon").hide();
            $("#p_type2").click();
            $("#p_type1").attr('disabled','disabled');
        } else {
            $("#order-user-id").val('');
            $(".non-anon").show();
            $("#user-select-list").hide();
            $("#p_type1").removeAttr('disabled');
        }
    });

    // 기간 선택시 날짜 채워지기
    $('input[name="date_p"]').change(function(){
        if($("#future_search").length) {
            if($("#future_search").val()==1) {
                if($(this).val()=='all') {
                    $('input[name="start_date"]').val('').effect("highlight");
                    $('input[name="end_date"]').val('').effect("highlight");
                } else {
                    setDateInput($(this).val());
                }
                return true;
            }
        }

        if($(this).val()=='all') {
            $('input[name="start_date"]').val('').effect("highlight");
            $('input[name="end_date"]').val('').effect("highlight");
        } else {
            setDateInput($(this).val());
        }
    });

    $('#no-sns-id').click(function(){
        $("#no-sns-login").show();
        $("#sns-login,#no-sns-id").hide();
        $("#no-sns-id").parent().hide();
    });

    $('#myModal').on('hidden.bs.modal', function () {
        $(this).removeData('bs.modal');
    });

    $('.modal_link').click(function(event){
        event.preventDefault();
        $('#myModal').removeData("modal");
        $('#myModal').load($(this).attr('href')+'?no_layout=true',function(){
            $('#myModal').modal();
        });
        return false;
    });

};

document.addEventListener("turbo:load", ready);