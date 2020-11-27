<%--
  Created by IntelliJ IDEA.
  User: Karson
  Date: 2020/7/31
  Time: 14:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page isELIgnored="false" %>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <%--引入jQuery--%>
    <script type="text/javascript" src="${pageScope.APP_PATH}/static/js/jquery-3.5.1.min.js"></script>
    <%--引入样式--%>
    <link href="${pageScope.APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
          rel="stylesheet"/>

    <script src="${pageScope.APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>


</head>
<body>
<%--员工修改的模态框--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_update_input"
                                   placeholder="email@karson.com" required="required">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked">
                                男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--部门提交部门ID即可--%>
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>


<%--员工添加的模态框--%>
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_input"
                                   placeholder="empName" required="required">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_input"
                                   placeholder="email@karson.com" required="required">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--部门提交部门ID即可--%>
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-10">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <%--显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_tables">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>department</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>

            </table>
        </div>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_area">
        </div>
        <%--分页条信息--%>
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>
</div>

<script type="text/javascript">

    var totalRecord, currentPage;

    //1.页面加载完成以后，直接发送ajax请求，要到分页请求
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                // console.log(result);
                //1.请求成功后，浏览器得到服务端的分页信息和员工信息响应
                //解析并显示数据
                build_emp_table(result);
                //2.解析并显示分页信息
                build_page_info(result);
                //3.解析显示分页条信息
                build_page_nav(result);
            }
        });
    }

    function build_emp_table(result) {
        //清空table
        $("#emps_tables tbody").empty();

        //获取json中的员工list
        var emps = result.extend.employeePageInfo.list;
        $.each(emps, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender === "M" ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append($("<span></span>")).addClass("glyphicon glyphicon-pencil").append("编辑");
            //为编辑按钮添加一个自定义属性，来表示当前员工的id
            editBtn.attr("edit_id", item.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append($("<span></span>")).addClass("glyphicon glyphicon-trash").append("删除");
            //为删除按钮添加一个自定义的属性，表示当前删除的员工id
            delBtn.attr("del_id", item.empId);
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            //append方法执行完以后还是返回原来的元素
            $("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(genderTd).append(emailTd).append(deptNameTd).appendTo("#emps_tables tbody").append(btnTd);
        });
    }

    //解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();

        $("#page_info_area").append("当前" + result.extend.employeePageInfo.pageNum +
            "页，总" + result.extend.employeePageInfo.pages +
            "页，总" + result.extend.employeePageInfo.total +
            "记录");

        totalRecord = result.extend.employeePageInfo.total;
        currentPage = result.extend.employeePageInfo.pageNum;
    }

    //解析显示分页条
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (result.extend.employeePageInfo.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.employeePageInfo.pageNum - 1);
            });
        }
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        if (result.extend.employeePageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            nextPageLi.click(function () {
                to_page(result.extend.employeePageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.employeePageInfo.pages);
            });
        }
        ul.append(firstPageLi).append(prePageLi);
        $.each(result.extend.employeePageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.employeePageInfo.pageNum === item)
                numLi.addClass("active");
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加首页和前一页的提示
        ul.append().append(nextPageLi).append(lastPageLi);
        //把ul加入到nav中
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //清空表单样式及内容
    function reset_form(ele) {
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").text("");
    }


    //点击新增按钮，弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //清除表单数据和样式
        reset_form("#empAddModal form");
        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts("#dept_add_select");
        //弹出模态框
        $("#empAddModal").modal({
            backdrop: "static"
        });
    });

    //查出所有的部门信息并显示在下拉列表中
    //传入选择器
    function getDepts(ele) {
        //清空之前下拉列表的值
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success: function (result) {
                //遍历result，把部门信息封装到<option>标签里
                $.each(result.extend.depts, function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    optionEle.appendTo(ele);
                });
            }
        });
    }

    //前端校验表单数据
    function validate_add_form() {
        //1.拿到要校验的数据，使用正则表达式
        var empName = $("#empName_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)) {
            show_validate_msg("#empName_input", "error", "用户名必须是2-5位中文或6-16位英文和数字的组合");
            return false;
        } else {
            show_validate_msg("#empName_input", "success", "");
        }

        //校验邮箱
        var empEmail = $("#email_input").val();
        var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
        if (!regEmail.test(empEmail)) {
            show_validate_msg("#email_input", "error", "邮箱格式错误");
            return false;
        } else {
            show_validate_msg("#email_input", "success", "");
        }
        return true;
    }

    //显示校验结果的提示信息
    function show_validate_msg(ele, status, msg) {
        //应该清空当前元素之前的状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }


    //校验用户名是否可用
    $("#empName_input").change(function () {
        //发送ajax请求，校验用户名是否可用
        var empName = this.value;
        $.ajax({
            url: "${APP_PATH}/checkuser",
            data: "empName=" + empName,
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_input", "success", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax_validate", "success");
                } else {
                    show_validate_msg("#empName_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax_validate", "error");
                }
            }
        });
    });

    //点击保存，保存员工
    $("#emp_save_btn").click(function () {

        //1.将模态框中填写的表单数据提交给服务器进行保存
        //先对要提交给服务器的数据进行前端校验
        if (!validate_add_form()) {
            return false;
        }
        //判断之前的ajax用户名校验是否成功
        if ($(this).attr("ajax_validate") == "error") {
            return false;
        }
        //2.发送ajax请求保存员工
        $.ajax({
            url: "${APP_PATH}/emp",
            type: "POST",
            data: $("#empAddModal form").serialize(),
            success: function (result) {
                // alert(result.msg);
                if (result.code == 100) {
                    //员工保存成功：
                    //1.关闭模态框
                    $("#empAddModal").modal("hide");
                    //2.来到最后一页，显示刚才保存的数据
                    //$("#empAddModal input").val("");//清空输入框的数据，防止再次打开的时候还有相同的数据
                    //发送ajax请求，显示最后一页
                    to_page(totalRecord + 1);
                } else {
                    //用户校验失败，显示失败信息
                    //有那个字段的错误信息，就显示哪个字段的错误信息
                    // console.log(result);
                    // alert(result.extend.errorFieldMap.email);
                    // alert(result.extend.errorFieldMap.empName);
                    if (undefined != result.extend.errorFieldMap.email) {
                        //显示邮箱错误信息
                        show_validate_msg("#email_input", "error", result.extend.errorFieldMap.email);
                    }
                    if (undefined != result.extend.errorFieldMap.empName) {
                        //显示员工名字的错误信息
                        show_validate_msg("#empName_input", "error", result.extend.errorFieldMap.empName);
                    }
                }
            }
        });
    });
    //
    //jQuery新版本没有live，使用on进行代替
    $(document).on("click", ".edit_btn", function () {
        reset_form("#empUpdateModal form");
        //1.查出部门信息，并显示部门列表
        getDepts("#dept_update_select");

        //2.查出员工信息，显示是员工信息
        getEmp($(this).attr("edit_id"));
        //3.把员工的id传递给员工的更新按钮
        $("#emp_update_btn").attr("edit_id", $(this).attr("edit_id"));
        $("#empUpdateModal").modal({
            backdrop: "static"
        });
    });

    function getEmp(id) {
        $.ajax({
            url: "${APP_PATH}/emp/" + id,
            type: "GET",
            success: function (result) {
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
        });
    }

    //点击更新，更新员工信息
    $("#emp_update_btn").click(function () {
        //验证邮箱是否合法
        //1.校验邮箱
        var empEmail = $("#email_update_input").val();
        var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
        if (!regEmail.test(empEmail)) {
            show_validate_msg("#email_update_input", "error", "邮箱格式错误");
            return false;
        } else {
            show_validate_msg("#email_update_input", "success", "");
        }
        //2.发送ajax请求，保存更新的信息
        $.ajax({
            url: "${APP_PATH}/emp/" + $(this).attr("edit_id"),
            type: "PUT",
            data: $("#empUpdateModal form").serialize(),
            success: function (result) {
                //修改完成，关闭模态框
                $("#empUpdateModal").modal("hide");
                //回到本页面
                to_page(currentPage);
            }
        });
    });
    //单个删除
    $(document).on("click", ".delete_btn", function () {
        //1.弹出是否确认删除确认框
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        if (confirm("确认删除【" + empName + "】吗？")) {
            //点击确认，发送ajax请求删除即可
            $.ajax({
                url: "${APP_PATH}/emp/" + $(this).attr("del_id"),
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    //回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    //完成全选和全不选按钮
    $("#check_all").click(function () {
        //dom原生属性的值使用prop来取，attr用来获取自定义属性的值
        $(".check_item").prop("checked", $(this).prop("checked"));
    });
    //check_item
    $(document).on("click", ".check_item", function () {
        //判断当前选中的元素是否是5个
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", flag)

    });

    //点击全部删除，就批量删除
    $("#emp_delete_all_btn").click(function () {

        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"), function () {
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            //组装员工id字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        //取出empNames多余的，
        empNames = empNames.substring(0, empNames.length - 1);
        del_idstr = del_idstr.substring(0, del_idstr.length - 1);
        if (empNames.length == 0) {
            alert("没有选中员工");
            return false;
        }
        if (confirm("确认删除【" + empNames + "】吗？")) {
            $.ajax({
                url: "${APP_PATH}/emp/" + del_idstr,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    //回到当前页面
                    to_page(currentPage);
                }
            });
        }
    });
</script>
</body>
</html>
