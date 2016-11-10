// JavaScript Document
$(function () {
    $(".tabShow .tabCaption li").click(
		function () {
		    $(this).addClass("on").siblings().removeClass("on");
		    var index = $(this).index()
		    $(this).parents(".tabShow").find(".tabContent").children(".tabBox").eq(index).addClass("on").siblings().removeClass("on");
		})

    $(".nav li").click(
		function () {
		    $(this).addClass("open").siblings().removeClass("open");
		    $(".nav li a").removeClass("a_red");
		    $(this).children().eq(0).addClass("a_red");
		})
})

// index广告滚动图
$(function () {
    var box = $('.main-c-3');
    if (box && box.length >= 1) {
        box.iFadeSlide({
            field: $('.main-c-3 a'),
            icocon: $('.ico'),
            hoverCls: 'high',
            curIndex: 0,
            inTime: 1000,
            interval: 5000
        })
    }
})