function myFileBrowser (field_name, url, type, win) {
		cmsURL = "/admin/assets/file_browser";
    tinyMCE.activeEditor.windowManager.open({
        file : cmsURL,
        title : 'File Browser',
        width : 350,  
        height : 150,
        resizable : "yes",
        inline : "yes",  
        close_previous : "no"
    }, {
        window : win,
        input : field_name
    });
    return false;
  }