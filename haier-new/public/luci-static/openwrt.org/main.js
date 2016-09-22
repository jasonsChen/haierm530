/**
 * Created by Administrator on 2016/9/18.
 */
//禁止表单自动填充
var IE8 = J('html.lt-ie9').length ? true : false;
J('from').attr('autocomplete','off');

//表单显示和隐藏密码
function showPassword(btn,input) {
    var type = true;
    J(btn).click(function(){
        J(input).each(function(i,o) {
            o.type = type ? 'text' : 'password';
        });
        type = !type;
    })
}

//隐藏和显示dom
function showDom (d,boolean) {
    if (IE8) {
        boolean = boolean ? 'none' : 'block';
        J(d).css({
            display: boolean
        })
    }else {
        J(d).changeClass('transi',true).changeClass('transf',boolean);
    }
}
