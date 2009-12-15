Wilderness = new Object();

/* 
EXTENDS PROTOTYPE TO SET CHECKED WITH INVOKE
http://cardarella.blogspot.com/2008/04/prototypejs-and-dom-attribute.html
*/
var dom_manip_methods = {
 setDOMAttribute: function(element, attr, value){
  element = $(element);
  eval("element." + attr + "=" + value + ";");
  return element;
 },
 getDOMAttribute: function(element, attr){
  element = $(element);
  return eval("element." + attr + ";");
 }
}
// Element.addMethods(dom_manip_methods);

/* TOGGLES CHECKBOXES FOR CONTROL (this) WITH CLASS NAMED IN ARGUMENT */
Wilderness.toggleCheckBoxes = function(control,class_name) {
  var state = jQuery(control).attr("checked");
	jQuery(class_name).attr("checked",state);
}

/* ACT ON CHECKED ITEMS */
Wilderness.act_on_checked = function(items,path) {       
	var action = jQuery('#act-on-checked').val();
  var collection = jQuery("."+items);
	var ids = new Array();
	
	jQuery.each(collection, function() { 
		id = jQuery(this).attr("id").split('[')[1].split(']')[0];
		value = jQuery(this).val(); 
		if(value == 'on') { 
			ids.push(id); 
			}
		});
		
	if (action != '') {
		url = path + action +"?ids="+ids
		jQuery.ajax({type: 'POST',dataType: 'script',url: url});
	} else {
		alert('Please select an action...');
	}
	return false;
}

Wilderness.filter = function(item,path) {
	window.location.href = path + "/?filter_by=" + item.value;
	return false;
}