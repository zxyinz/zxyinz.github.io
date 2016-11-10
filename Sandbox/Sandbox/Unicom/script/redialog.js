/************************************************
 *  Copyright(R) by jzchen, (www.jzchen.net)
 *	April 19th, 2003
 ************************************************/
/*
 * redialog.js, the main script.
 * you just have include this file.
 */


// before you use this script you have to change "rdHome" the your own directry.
// otherwise, it won't work.

var rdHome = "../njs/redialog/";

// the basic width
var rdBasicWidth = "360px";

// the basic height
var rdBasicHeight = "180px";




/***************** USER'S OWN CONIFGUATION ENDS ************************/
/************ DONOT MODIFY THE CODE BELOW, JUST SEE THE HELP.***********/


// The mode of dialog
var rdModeError = 0;
var rdModeInfo = 1;
var rdModeOk = 2;

// The return value of the dialog
var rdConstOK = 1;
var rdConstCancel = 0;
var rdConstRetry = 2;
var _g_privateDialogFeatures = "status=no;center=yes;help=no;dialogWidth=" + rdBasicWidth + ";dialogHeight=" + rdBasicHeight + ";scroll=yes;resize=no";

/**
 * rdShowDialog()
 * No use at present.
 */
function rdShowDialog() {}





/**
 * rdShowMessageDialog
 * param message the message you want to show. to make beautiful, it's length is 
 *				suggested to be less then 100.
 * param mode the mode of the dialog, may be one of the choice:
 *				rdModeError(0) or rdModeInfo(1), this inflect the icon of the dialog.
 * return the user's choice. may be the in the 3 of rdConstOK(1), rdConstCancle(0),
 *				rdConstRetry(2)
 */
function rdShowMessageDialog(message, mode, basePath)
{
    var w;
    var args;
    // Check the parameter "message"
    if (typeof (message) == "undefined")
    {
        args = "";
    }
    else
    {
        args = message;
    }
    // Check the parameter "mode"
    if (typeof (mode) != "undefined") {
        if (mode == rdModeError || mode == rdModeInfo || mode == rdModeOk)
            args = args + "|" + mode;
    }

    if (typeof (basePath) != "undefined") {
        w = window.showModalDialog(basePath + "/njs/redialog/core/message.html",
                                         args, _g_privateDialogFeatures);
    } else {
        w = window.showModalDialog(rdHome + "core/message.html",
                                         args, _g_privateDialogFeatures);
    }
    return w;
}


/**
 * rdShowInputDialog
 * param message the message you want to show. to make beautiful, it's length is 
 *				suggested to be less then 100.
 * param mode the mode of the dialog, may be one of the choice:
 *				rdModeError(0) or rdModeInfo(1), this inflect the icon of the dialog.
 * return the user's input. if nothing is inputed, "" is returned.
 */
function rdShowInputDialog(message, mode, input) {
    var args;
    var w;
    var inputval;

    // Check the parameter "messge"
    if (typeof (message) == "undefined")
    {
        args = "";
    }
    else
    {
        args = message;
    }

    // Check the parameter "mode"
    if (typeof (mode) != "undefined")
    {
        if (mode == rdModeError || mode == rdModeInfo || mode == rdModeOk) { args = args + "|" + mode; }
    }

    // Check the parameter "input"
    if (typeof (input) == "undefined")
    {
        inputval = "";
    }
    else
    {
       inputval = input;
    }
    var w = window.showModalDialog(rdHome + "core/input.jsp?rdInput=" + inputval, args, _g_privateDialogFeatures);

    return w;
}



/**
 * rdShowMessageDialog
 * param message the message you want to show. to make beautiful, it's length is 
 *				suggested to be less then 100.
 * param mode the mode of the dialog, may be one of the choice:
 *				rdModeError(0) or rdModeInfo(1), this inflect the icon of the dialog.
 * return the user's choice. may be the in the 3 of rdConstOK(1), rdConstCancle(0),
 *				rdConstRetry(2)
 */
function rdShowConfirmDialog(message, mode, basePath) {

    var args;
    var w;
    // Check the parameter "message"
    if (typeof (message) == "undefined")
    {
        args = "";
    }
    else
    {
        args = message;
    }


    // check the parameter "mode"
    if (typeof (mode) != "undefined")
    {
        if (mode == rdModeError || mode == rdModeInfo || mode == rdModeOk)
            args = args + "|" + mode;
    }
    if (typeof (basePath) != "undefined")
    {
        w = window.showModalDialog(basePath + "/njs/redialog/core/confirm.html", args, _g_privateDialogFeatures);
    }
    else
    {
        w = window.showModalDialog(rdHome + "core/confirm.html",  args, _g_privateDialogFeatures);
    }

    return w;
}

function judgePurview(citysid, fun)
{
    var url = "../judgePurview.do";
    var params = "citysid=" + citysid;
    var funstr = "fun(";
    if (arguments.length == 2) funstr = "fun()";
    if (arguments.length > 2)
    {
        for (var i = 2; i < arguments.length; i++)
        {
            var pam = "";
            if (typeof (arguments[i]) == "string")
            {
                pam = "'" + arguments[i] + "'";
            }
            else
            {
                pam = arguments[i]
            }
            if (i < arguments.length - 1)
            {
                funstr += pam + ",";
            }
            else
            {
                funstr += pam + ")";
            }
        }
    }
    $.ajax({
        type: "POST",
        url: url,
        data: params,
        success: function (data)
        {
            if ("true" == data)
            {
                eval(funstr);
            }
            else
            {
                alert("Ã»ÓÐÈ¨ÏÞ!!!");
            }

        }
    });
}
