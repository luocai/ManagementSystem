<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    pageContext.setAttribute("path", path);
    pageContext.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html>
<head>
    <base href="basePath">
    <meta charset="utf-8">
    <title>员工信息</title>
    <script type="text/javascript" src="static/js/jquery/jquery.min.js"></script>
    <!--引入样式-->
    <link href="static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <style>
        .pageMessage{
            width: 50%;
            height: 70px;
            line-height: 70px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h2>
                信息管理
            </h2>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-sm btn-info pull-right">新增</button>
            <button class="btn btn-sm btn-danger pull-right">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>邮箱</th>
                        <th>部门</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>


                </tbody>

            </table>
        </div>
    </div>
    <div class="row">
        <!--分页详情-->
        <div class="col-md-6 pageMessage" id="page_info_area">
        </div>
        <!--分页组件-->
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<script type="text/javascript">
//1.页面加载完成后直接去发ajax请求
    $(function(pn){
        to_page(1);
    });

    function to_page(pn){
        $.ajax({
            url:"emps",
            data:"pn="+pn,
            type:"GET",
            success:function(result){
                //1.解析显示员工信息
                build_emps_table(result);
                //2. 解析显示分页信息
                build_page_info(result);
                //3. 解析显示分页条
                build_page_nav(result);
            }
        });
    }

    function build_emps_table(result){
        //清空表格
        $("#emps_table tbody").empty();
        var emps = result.data.pageInfo.list;
        $.each(emps,function(index,item){
            var empIdTd    = $("<td></td>").append(item.empId);
            var empNameTd  = $("<td></td>").append(item.empName);
            var genderTd   = $("<td></td>").append(item.gender=="M"?"男":"女");
            var emailTd    = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-info btn-xs")
                         .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append(" ");
            var delBtn  = $("<button></button>").addClass("btn btn-danger btn-xs")
                         .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append(" ");
            var btnTd   = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");
        });
    }

    //解析显示分页信息
    function build_page_info(result){
        $("#page_info_area").empty();
        $("#page_info_area").append("当前第"+
                result.data.pageInfo.pageNum+"页,总共"+
                result.data.pageInfo.pages+"页，总共"+
                result.data.pageInfo.total+"条记录");
    }
    //解析显示分页条,点击事件
    function build_page_nav(result){
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
        var prePageLi    = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(!result.data.pageInfo.hasPreviousPage){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //首页上一页添加事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.data.pageInfo.pageNum - 1);
            });
        }


        var nextPageLi    = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi  = $("<li></li>").append($("<a></a>").append("尾页"));
        if(!result.data.pageInfo.hasNextPage){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            //尾页下一页添加事件
            nextPageLi.click(function () {
                to_page(result.data.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.data.pageInfo.pages);
            });
        }


        // 首页前一页
        ul.append(firstPageLi).append(prePageLi);
        // 遍历得到页码
        $.each(result.data.pageInfo.navigatepageNums,function(index,item){
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.data.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            //点击重新请求
            numLi.click(function(){
                to_page(item);
            });
            ul.append(numLi);
        });
        // 下一页末页
        ul.append(nextPageLi).append(lastPageLi);
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
</script>
</body>
</html>
