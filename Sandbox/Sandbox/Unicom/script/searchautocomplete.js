//高亮索引
var highlightindex = -1;
//设置文本框的内容
function setContent(con, index)
{
    var context = con.eq(index).text();
    $("#context").val(context);
}
//设置背景颜色
function setBkColor(con, index, color)
{
    con.eq(index).css("background-color", color);
}
$(document).ready(
function ()
{
    //获得输入框节点
    var inputItem = $("#context");
    var inputOffset = inputItem.offset();
    var autonode = $("#auto");
    //设置提示框隐藏
    //autonode.hide().css("border","1px #666 solid").css("position","absolute")
    // .css("top",inputOffset.top+inputItem.height()+5+"px")
    //.css("left",inputOffset.left+"px").width(inputItem.width()+"px"); 
    //当键盘抬起时触发事件执行访问服务器业务
    $("#context").keyup(
     function (event) {
         var myevent = event || window.event;
         var mykeyCode = myevent.keyCode;
         //字母，退格，删除，空格  ||mykeyCode==16
         if ((mykeyCode >= 65 && mykeyCode <= 90) || (mykeyCode >= 48 && mykeyCode <= 57) || mykeyCode == 8 || mykeyCode == 46 || mykeyCode == 32) {
             //清除上一次的内容
             autonode.html(" ");
             //获得文本框内容
             var word = $("#context").val();
             if (event.keyCode == 13)
             {
                 if (word == null || "" == word)
                 {
                     alert("请输入关键词");
                     return;
                 }
             }
             var timeDelay;
             if (word != "")
             {
                 //取消上次提交
                 window.clearTimeout(timeDelay);
                 //延迟提交，这边设置的为400ms
                 timeDelay = window.setTimeout(
                  //将文本框的内容发到服务器
                  $.post("/elnSearchAutoComplete.do", { wordtext: encodeURI(word) },
                   function (data)
                   {
                       //将返回数据转换为JQuery对象
                       if ($.browser.msie)
                       {
                           xml = new ActiveXObject("Microsoft.XMLDOM");
                           xml.async = false;
                           xml.loadXML(data);
                       }
                       else
                       {
                           xml = new DOMParser().parseFromString(data, "text/xml");
                       }
                       var jqObj = $(xml);
                       //找到所有的word节点
                       var wordNodes = jqObj.find("word");
                       wordNodes.each(function (i)
                       {
                           //获得返回的单词内容
                           var wordNode = $(this);
                           var newNode = $("<div>").html(wordNode.text()).attr("id", i).addClass("pro");
                           //将返回内容附加到页面
                           newNode.appendTo(autonode);
                           //处理鼠标事件
                           var con = $("#auto").children("div");
                           //鼠标经过
                           newNode.mouseover(
                            function ()
                            {
                                if (highlightindex != -1)
                                {
                                    setBkColor(con, highlightindex, "white");
                                }
                                highlightindex = $(this).attr("id");
                                $(this).css("background-color", "#ADD8E6");
                                setContent(con, highlightindex);
                            }
                           );
                           //鼠标离开
                           newNode.mouseout(
                            function ()
                            {
                                $(this).css("background-color", "white");
                            }
                           );
                           //鼠标点击.click事件不起作用，只能用mousedown事件
                           newNode.mousedown(
                            function ()
                            {
                                highlightindex = $(this).attr("id");
                                setContent(con, highlightindex);
                                searchKnowledge();
                            }
                           );
                       })
                       //each
                       //当返回的数据长度大于0才显示
                       if (wordNodes.length > 0)
                       {
                           autonode.show();
                       }
                       else
                       {
                           autonode.hide();
                       }
                   })
                  , 1000);    //settimeout
             }
             else
             {
                 autonode.hide();
                 highlightindex = -1;
             }
         }
         else
         {
             //获得返回框中的值
             var rvalue = $("#auto").children("div");
             //上下键
             if (mykeyCode == 38 || mykeyCode == 40)
             {
                 //向上
                 if (mykeyCode == 38)
                 {
                     if (highlightindex != -1)
                     {
                         setBkColor(rvalue, highlightindex, "white");
                         highlightindex--;
                     }
                     if (highlightindex == -1)
                     {
                         setBkColor(rvalue, highlightindex, "white");
                         highlightindex = rvalue.length - 1;
                     }
                     setBkColor(rvalue, highlightindex, "#ADD8E6");
                     setContent(rvalue, highlightindex);
                 }
                 //向下
                 if (mykeyCode == 40)
                 {
                     if (highlightindex != rvalue.length)
                     {
                         setBkColor(rvalue, highlightindex, "white");
                         highlightindex++;
                     }
                     if (highlightindex == rvalue.length)
                     {
                         setBkColor(rvalue, highlightindex, "white");
                         highlightindex = 0;
                     }
                     setBkColor(rvalue, highlightindex, "#ADD8E6");
                     setContent(rvalue, highlightindex);
                 }
             }
             //回车键
             if (mykeyCode == 13)
             {
                 if (highlightindex != -1)
                 {
                     (rvalue, highlightindex);
                     highlightindex = -1;
                     autonode.hide();
                 }
                 else
                 {
                     searchKnowledge();
                 }
             }
         }
     }
    );//键盘抬起
    //当文本框失去焦点时的做法
    inputItem.focusout(
     function ()
     {
         //隐藏提示框
         autonode.hide();
     }
    );
}
);

// 控制高级搜索取的显示
function showAdvSearchTD()
{
    var typeObj = document.getElementById('tdSystemName');
    var state;
    if (typeObj.style.display == 'none')
    {
        state = '';
        document.getElementById('tdCourseTypeName').style.display = '';
        document.getElementById('tdCourseTypeValue').style.display = '';
        document.getElementById('tdCitysidName').style.display = '';
        document.getElementById('tdCitysidValue').style.display = '';
        document.getElementById('tdSystemName').style.display = '';
        document.getElementById('tdSystemNameValue').style.display = '';
        showAdvSearchSelect();

    }
    else
    {
        state = 'none';
        document.getElementById('tdCourseTypeName').style.display = 'none';
        document.getElementById('tdCourseTypeValue').style.display = 'none';
        document.getElementById('tdCitysidName').style.display = 'none';
        document.getElementById('tdCitysidValue').style.display = 'none';
        document.getElementById('tdSystemName').style.display = 'none';
        document.getElementById('tdSystemNameValue').style.display = 'none';
    }
}
function showAdvSearchDiv()
{

    var typeObj = document.getElementById('tdSystemName');
    if (typeObj.style.display == '')
    {
        showAdvSearchSelect();
    }

}
function showAdvSearchSelect()
{

    if (searchType == IDX_TYPE_DOC)
    {
        document.getElementById('tdCourseTypeName').style.display = '';
        document.getElementById('tdCourseTypeValue').style.display = '';
        document.getElementById('courseType').style.display = '';
        document.getElementById('testType').style.display = 'none';
        document.getElementById('citysidList').style.display = '';
        document.getElementById('tdSystemName').style.display = '';
        document.getElementById('systemName').style.display = '';


    } else if (searchType == IDX_TYPE_LESSON)
    {
        document.getElementById('tdCourseTypeName').style.display = '';
        document.getElementById('tdCourseTypeValue').style.display = '';
        document.getElementById('courseType').style.display = '';
        document.getElementById('testType').style.display = 'none';
        document.getElementById('citysidList').style.display = '';
        document.getElementById('tdSystemName').style.display = '';
        document.getElementById('systemName').style.display = '';


    } else if (searchType == IDX_TYPE_TEST)
    {
        document.getElementById('tdCourseTypeName').style.display = '';
        document.getElementById('tdCourseTypeValue').style.display = '';
        document.getElementById('courseType').style.display = 'none';
        document.getElementById('testType').style.display = '';
        document.getElementById('citysidList').style.display = '';
        document.getElementById('tdSystemName').style.display = '';
        document.getElementById('systemName').style.display = '';

    } else if (searchType == IDX_TYPE_ALL)
    {
        document.getElementById('tdCourseTypeName').style.display = 'none';
        document.getElementById('tdCourseTypeValue').style.display = 'none';
        document.getElementById('courseType').style.display = 'none';
        document.getElementById('testType').style.display = 'none';
        document.getElementById('citysidList').style.display = '';
        document.getElementById('tdSystemName').style.display = '';
        document.getElementById('systemName').style.display = '';
    }



}
function getAdvSearchParams()
{
    var obj;
    var type = '';
    var citysid = '';
    var sys = '';
    if (searchType == IDX_TYPE_DOC)
    {
        obj = document.getElementById('courseType');
        type = obj.value;
        citysid = document.getElementById('citysidList').value;
        sys = document.getElementById('systemName').value
    }

    else if (searchType == IDX_TYPE_LESSON)
    {
        obj = document.getElementById('courseType');
        type = obj.value;
        citysid = document.getElementById('citysidList').value;
        sys = document.getElementById('systemName').value
    }
    else if (searchType == IDX_TYPE_TEST)
    {
        obj = document.getElementById('testType');
        type = obj.value;
        citysid = document.getElementById('citysidList').value;
        sys = document.getElementById('systemName').value
    }
    else
    {
        type = '';
        citysid = document.getElementById('citysidList').value;
        sys = document.getElementById('systemName').value
    }


    return "&type=" + type + "&citysid=" + citysid + "&sys=" + sys;
}