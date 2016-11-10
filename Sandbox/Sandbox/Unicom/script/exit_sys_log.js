var jspIndex;
var isTheSamePageClicked = false;
var INNERPageCount = 1;
/**
 * 当点击链接时，将jspIndex设置为要跳转的页面的index，原页面执行onunload方法 在jsLoginout中判断是否相等。不相等则为页面跳转
 * 在跳转后的页面的onload方法中将jspIndex设置为跳转后页面的index,如果有关闭浏览器等动作会执行onunload方法，判断index是否相等，如果相等则是页面关闭
 * 如果点击的链接会在新标签中打开页面，则需要将这样的页面index排除。比如79：bbs。80:系统管理
 * @param {Object} index 页面index
 * @return {TypeName} 
 */
function jsLoginout(index)
{
    // 不相等表示菜单切换
    //		if (index != jspIndex && jspIndex != 79 && jspIndex != 80  ) {
    //			
    //			return;
    //		}
    //alert(isTheSamePageClicked);
    //点击相同的菜单两次导致的onunload事件
    //		if (isTheSamePageClicked) {
    //			return ;
    //		}

    // 在新标签中打开的页面在onclick事件中需要将这个置为false。
    //		if (isTrueLoginout == false) {
    //			return;
    //		}
    //		if (typeof(INNERPageCount) != 'undefined') {
    //			INNERPageCount =  INNERPageCount - 1;
    //
    //			if (INNERPageCount > 0) {
    //				return;
    //			}		}

    //window.location.href = '../exitSystem.do';
    var url = '../../exitSystem.do';
    $.ajax(
    {
        type: "POST",
        url: url,
        success: function (msg) {}
    });
    // 点击选项卡的关闭按钮、浏览器关闭按钮 或者 alt+f4 或者 ctrl+w 或者 右键任务栏关闭窗口  (documentElement w3c 标准)
    //		if ((event.clientY < 0) || (event.altKey == true ) || (event.ctrlKey == true) || (event.clientY >= document.body.clientHeight ||  event.clientY >= document.documentElement.clientHeight)) {
    //					window.location.href = '../exitSystem.do';
    //		}


}
function jsLoginCount()
{
    var url = '/countSession.do';
    $.ajax(
    {
        type: "POST",
        url: url,
        success: function (msg) {}
    });
}
function setUnLoginout()
{
    isTrueLoginout = false;
}