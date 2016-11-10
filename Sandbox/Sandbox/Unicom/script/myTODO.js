function getMyTOTOInfo()
{
    var url = "/queryPortalIndexMeetingAndSMS.do";
    var params = "";
    $.ajax(
    {
        type: "POST",
        url: url,
        data: params,
        success: function (msg)
        {
            var arr = msg.split('~');
            var verifyCount = arr[0];
            var examCount = arr[1];
            var courseCount = arr[2];
            var feedBackCount = arr[3];
            var meetingCount = arr[4];
            var smsCount = arr[5];
            var bugCount = arr[6];

            document.getElementById('verifyCount').innerText = '(' + verifyCount + ')';
            document.getElementById('examCount').innerText = '(' + examCount + ')';
            document.getElementById('courseCount').innerText = '(' + courseCount + ')';
            document.getElementById('feedBackCount').innerText = '(' + feedBackCount + ')';
            document.getElementById('meetingCount').innerText = '(' + meetingCount + ')';
            document.getElementById('smsCount').innerText = '(' + smsCount + ')';
            document.getElementById('bugCount').innerText = '(' + bugCount + ')';

        }
    });
}

function openSmsInfo(sParam)
{
    //alert(sParam);		
    var time = new Date();
    var ret = window.showModalDialog('/elnsysmanage/sysSmsMain.jsp?userid=' + sParam + "&" + time, window, 'dialogWidth:780px;dialogHeight:460px;center:yes;scroll:yes;help:no;resizable:no;status:no');
}

function modifyPassword()
{
    window.showModalDialog("/showmypasswordmodify.do", window, "dialogWidth:780px;dialogHeight:460px;center:yes;scroll:yes;help:no;resizable:no;status:no");
}
function loadWaitingVerifyPage()
{
    //window.showModalDialog("../portal/verifyPage.jsp", window,"dialogWidth:780px;dialogHeight:460px;center:yes;scroll:yes;help:no;resizable:yes;status:yes");
    window.open("../verifyPage.jsp", "verifyPage", "height=" + screen.height + "px, width=" + screen.width + "px, top=0px, left=0px, scrollbars=yes, resizable=no, location=no, status=yes");

}
function loadExamPage()
{
    window.open("../myExamPage.jsp", "verifyPage", "height=" + screen.height + "px, width=" + screen.width + "px, top=0px, left=0px, scrollbars=yes, resizable=no, location=no, status=yes");

}
function loadCoursePage()
{
    window.open("../myCoursePage.jsp", "verifyPage", "height=" + screen.height + "px, width=" + screen.width + "px, top=0px, left=0px, scrollbars=yes, resizable=no, location=no, status=yes");

}
function loadFeedBackPage()
{
    window.open("../myfeedBackPage.jsp", "verifyPage", "height=" + screen.height + "px, width=" + screen.width + "px, top=0px, left=0px, scrollbars=yes, resizable=no, location=no, status=yes");

}
function loadBugPage()
{
    window.open("myBugPage.jsp", "verifyPage", "height=" + screen.height + "px, width=" + screen.width + "px, top=0px, left=0px, scrollbars=yes, resizable=no, location=no, status=yes");
}

function loginmeeting()
{
    var time = new Date();
    var url = "../../eln_livechat/meetingList.jsp";
    window.open(url, "meeting", "height=" + screen.height + "px, width=" + screen.width + "px, top=0px, left=0px, scrollbars=yes, resizable=no, location=no, status=yes");
    //var time=new Date();	
    //var url="/eln_livechat/meetingList.jsp";
    //window.open(url,"meeting","modal=yes,width="+window.screen.width/2+",height="+window.screen.height/2+",resizable=no,scrollbars=no,status=no,toolbar=no,menubar=no");	
}