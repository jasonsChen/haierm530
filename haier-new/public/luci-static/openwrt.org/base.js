/* 
*    cJate by JJ 2016/8/22  兼容到IE8
*/

(function (window) {
var J_obj = function () {  //J对象方法的原型
};



/*----------------------------------------------------------基本操作类--------------------------------------------------------------*/



//J对象遍历.each函数接受一个参数fn，fn为函数，each函数会在遍历J对象时给fn传入两个参数，index和dom，并执行fn。
J_obj.prototype.each = function(fn) {
	for (var i = 0; i < this.length; i++) {
		fn(i,this[i]);
	};
	return this;
};


// css 方法 设置css传入两个字符串参数或者一个对象形式如 "color","red" 或者 {color:"red"} ，将会设置this的style的属性。获取css属性传入一个字符串参数，获取this的行内样式。
J_obj.prototype.css = function () {
	if (arguments.length == 1 && typeof arguments[0] == "string") {
		if (this.length == 1) {
			return this[0].style[arguments[0]];
		}else {
			if (this.length == 0) {
				console.log("没找到要获取样式的对象");
			}else {
				console.log("只能获取单个对象的样式");
			}
		}

	}else if (arguments.length == 1 && typeof arguments[0] == "object") {
		for (var i = 0; i < this.length; i++) {
			for(k in arguments[0]) {
				this[i].style[k] = [arguments[0][k]];
			}
		};
	}else if (arguments.length == 2 && typeof arguments[0] == "string") {
		arguments[1] = typeof arguments[1] == "string" ? arguments[1] : !!arguments[1];
		for (var i = 0; i < this.length; i++) {
			this[i].style[arguments[0]] = arguments[1];
		};
	}
	return this;
}

// attr 方法参数规则同上（css方法）。将会设置或者获取this的属性。
J_obj.prototype.attr = function () {
	if(arguments.length == 1 && typeof arguments[0] == "string") {
		if (this.length == 1) {
			return this[0][arguments[0]];
		}else {
			if (this.length == 0) {
				console.log("没找到要获取样式的对象");
			}else {
				console.log("只能获取单个对象的样式");
			}
		}
	}else if (arguments.length == 1 && typeof arguments[0] == "object") {
		for (var i = 0; i < this.length; i++) {
			for(k in arguments[0]) {
				this[i][k] = [arguments[0][k]];
			}
		};
	}else if (arguments.length == 2 && typeof arguments[0] == "string") {
		arguments[1] = typeof arguments[1] == "string" ? arguments[1] : !!arguments[1];
		for (var i = 0; i < this.length; i++) {
			this[i][arguments[0]] = arguments[1]
		};
	}
	return this;
}

//添加或删除classname 传入两个参数 calssname:str类型,method:boolean,true 表示增加class,false表示删除.默认为添加
J_obj.prototype.changeClass = function (classname,method) {
	typeof method == "undefined" && ( method = true );
	if(method) {
		for (var i = 0; i < this.length; i++) {
			this[i].className += ( " " + classname );
		};
	}else {
		for (var i = 0; i < this.length; i++) {
			var r = "\\b" + classname + "\\b";
			var reg = new RegExp(r,"g");
			this[i].className = this[i].className.replace(reg,"")
		};
	}
	return this;
}


// 事件绑定,传入两个参数，type为事件类型，handle为事件触发后执行的函数。
J_obj.prototype.addEvent = function (type,handle) {
	for (var i = 0; i < this.length; i++) {
		(function (obj,type,handle){
		    try{  // Chrome、FireFox、Opera、Safari、IE9.0及其以上版本
		        obj.addEventListener(type,handle,false);
		    }catch(e){
		        try{  // IE8.0及其以下版本
		            obj.attachEvent('on' + type,handle);
		        }catch(e){  // 早期浏览器
		            obj['on' + type] = handle;
		        }
		    }
		})(this[i],type,handle);
	};
	return this;
};


//click 方法，传入一个函数参数handle，触发click事件后只是handle函数
J_obj.prototype.click = function (fn) {
	for (var i = 0; i < this.length; i++) {
		this[i].onclick = fn;
	};
	return this;
};



/*----------------------------------------------------------浏览器相关类--------------------------------------------------------------*/
//返回滚动条滚动的距离
J_obj.prototype.scrollTop = function (e) {
	if (this[0] === window) {
		return document.documentElement.scrollTop || document.body.scrollTop;
	};
	
};















/*-----------------------------------------------------------插件类-------------------------------------------------------------------*/


//模拟alert 弹框,传入三个字符串参数和一个回调函数，title:标题,content内容，submitstr：按钮内容，callback：回调函数。均为可选参数，callback必须为最后一个参数；
J_alert = function (content,title,submitstr,callback) {
	if (arguments.length == 1 && typeof arguments[0] === "function") {
		callback = arguments[0];
		content = null;
	}else if (arguments.length == 2 && typeof arguments[1] === "function") {
		callback = arguments[1];
		title = null;
	}else if (arguments.length == 3 && typeof arguments[2] === "function") {
		callback = arguments[2];
		submitstr =null;
	};
	content = !!content ? content : "";
	title = !!title ? title : "消息！";
	submitstr = !!submitstr ? submitstr : "确定";
	var  oDiv = document.createElement("div");
	J(oDiv).css({position: "fixed",top: "0",bottom: "0",left: "0",right: "0",backgroundColor: "rgba(100,100,100,.2)",margin: "auto"});
	oDiv.innerHTML = '<div style="position: absolute;width: 80%;max-width: 500px;height: 200px;top: 0;bottom: 0;left: 0;right: 0;margin: auto;border: 1px solid #ccc;border-radius: 3px;box-shadow: 5px 5px 31px 0 #ccc;"><div style="background: #ccc;height: 30px;"><span style="float: left;height: 20px;line-height: 20px;padding: 5px 10px;">' + title + '</span><span class="J_alert" style="float: right;height: 20px;line-height: 20px;padding: 5px 10px;cursor: pointer;">×</span></div><div style="height: 110px;padding: 5px 20px;">' + content + '</div><div style="height: 20px;padding: 5px 10px;text-align: center;"><button class="J_alert" style="margin: 0 60px;">' + submitstr + '</button></div></div>';
	document.body.appendChild(oDiv);
	J(".J_alert").click(function() {
		document.body.removeChild(oDiv);
		!!callback && typeof callback == "function" && callback();
	})

}

//模拟confirm 弹框,传入三个字符串参数和一个回调函数，title:标题,content内容，submitstr：按钮内容，callback：回调函数。均为可选参数，callback必须为最后一个参数；

J_confirm = function (content,title,submitstr,resetstr,callback) {
	if (arguments.length == 1 && typeof arguments[0] === "function") {
		callback = arguments[0];
		content = null;
	}else if (arguments.length == 2 && typeof arguments[1] === "function") {
		callback = arguments[1];
		title = null;
	}else if (arguments.length == 3 && typeof arguments[2] === "function") {
		callback = arguments[2];
		submitstr =null;
	}else if (arguments.length == 3 && typeof arguments[3] === "function") {
		callback = arguments[2];
		resetstr =null;
	};
	content = !!content ? content : "";
	title = !!title ? title : "消息！";
	submitstr = !!submitstr ? submitstr : "确定";
	resetstr = !!resetstr ? resetstr : "取消";
	var  oDiv = document.createElement("div");
	J(oDiv).css({position: "fixed",top: "0",bottom: "0",left: "0",right: "0",backgroundColor: "rgba(100,100,100,.2)",margin: "auto"});
	oDiv.innerHTML = '<div style="position: absolute;width: 80%;max-width: 500px;height: 200px;top: 0;bottom: 0;left: 0;right: 0;margin: auto;border: 1px solid #ccc;border-radius: 3px;box-shadow: 5px 5px 31px 0 #ccc;"><div style="background: #ccc;height: 30px;"><span style="float: left;height: 20px;line-height: 20px;padding: 5px 10px;">' + title + '</span><span class="J_alert" style="float: right;height: 20px;line-height: 20px;padding: 5px 10px;cursor: pointer;">×</span></div><div style="height: 110px;padding: 5px 20px;">' + content + '</div><div style="height: 20px;padding: 5px 10px;text-align: center;"><button data-value="true" class="J_alert" style="margin: 0 60px;">' + submitstr + '</button><button class="J_alert" style="margin: 0 60px;">' + resetstr + '</button></div></div>';
	document.body.appendChild(oDiv);
	J(".J_alert").click(function() {
		console.log();
		document.body.removeChild(oDiv);
		!!callback && typeof callback == "function" && callback(!!this.getAttribute("data-value"));
	})

}



/*
* Ajax 请求的封装******************************************************************
*/
// ajax方法  path:str 请求的路径; body:obj, 请求体; callback: readystatechange的时候触发;
J_ajax = function (path,type,body,callback) {
	var xhr;
	var params = formatParams(body);
	type = (type || "GET").toUpperCase();
	if (window.XMLHttpRequest) {
		xhr = new XMLHttpRequest();
	}else {
		xhr =new ActiveXObject("Microsoft.XMLHTTP");
	}
	xhr.onreadystatechange = function () {
		callback(xhr);
	}
	if (type == "GET") {
		xhr.open("GET",path + "?" + params,true);
		xhr.send();
	}else if(type == "POST") {
		xhr.open("POST",path,true);
		xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xhr.send(params);
	}
	function formatParams (data) {
		var arr =[];
		for(var i in data){
        arr.push(i + "=" + data[i])
    	}
    	return arr.join("&");
	}
}











































//  构建J选择器，生成J对象.  原型为J_obj，给J对象添加获取的dom对象，************(length的问题有待解决)***********
var J = function (e) {
	var obj = new J_obj();
	var elements = typeof e == "string" ? document.querySelectorAll(e) : ( e instanceof Array ? e : [e] );
	for (var i=0;i<elements.length;i++) {
		obj[i] = elements[i];
	}
	obj["length"] = elements.length;
	return obj;
}


















window.J = J;

})(window);



