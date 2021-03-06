Polymer({
	model : '',	// name of model in backend
	m : null,	// instance of model for binding
	models : [],	// array of models being displayed
	params: '',		// parameters to pass to REST query
	readonly: false,  // show edit/del/add

	// Columns to render in list (space-separated)
	cols : "name",
	columns : function() {
		// return the columns as an array
		return this.cols.split(" ");
	},

	// external operations
	actions: "",
	operations: [],	
	onAction: "",
	
	// Called when component is ready to render
	ready : function() {
		if (this.model == '') {
			alert('Model not defined for data-table');
			return;
		}
		
		if (this.childElementCount == 0) {
			this.readonly = true;
		}

		// load external operations
		if (this.actions.trim().length > 0) {
			this.operations = this.actions.split(" ");
		} else {
			this.operations = []			
		}
		
		this.loadData(1);
	},

	// Called to load the edit form for "add new" or "edit" operations
	loadForm: function() {
		// render edit form with bindings to model as "m" variable
		var editForm = this.children[0];
		var formHTML = editForm.innerHTML.replace(new RegExp("\\[\\[", "g"), "{{");
		formHTML = formHTML.replace(new RegExp("\\]\\]", "g"), "}}");
		this.injectBoundHTML(formHTML, this.$.model_form);
		
		// hide data table
		this.$.data_table.style.display = 'none';
		this.$.data_table.style.visibility = 'hidden';
	},
	
	// Called when "edit" button is clicked
	edit : function(e, detail, sender) {
		var m = e.target.templateInstance.model.m;
		this.m = m;
		this.loadForm();
	},

	// called when "add new" is clicked
	create: function() {
		this.m = {};
		this.loadForm();
	},

	// Generic user-defined operation callback. It will call the javascript function
	// defined in the onAction attribute with operation and model details.
	operation: function(e, detail, sender) {
		var model = e.target.templateInstance.model;
		if (this.onAction && this.onAction.trim().length > 0) {
			var fn = window[this.onAction];
			if (fn && typeof fn === 'function') {
				fn(model.o, model.m);
			}
		}
	},
	
	// called to load a page from the paginator (i.e. page number clicked)
	loadPage : function(e, detail, sender) {
		var p = e.target.templateInstance.model.pIndex + 1;
		this.loadData(p);
	},

	// load previous page from paginator
	previousPage : function() {
		if (this.page > 1) {
			this.page = this.page - 1;
			this.loadData(this.page);
		}
	},

	// load next page from paginator
	nextPage : function() {
		if (this.page < this.pages) {
			this.page = this.page + 1;
			this.loadData(this.page);
		}
	},

	// display data in a list for the specified page. Backend decides how many items per page.
	loadData : function(page) {
		scope = this;
		
		if (page) {
			this.page = page;
		}

		// load data
		var request = $.ajax({
			url : "/api/v1/" + this.model + "?page=" + this.page + "&" + this.params,
			type : "GET",
			// data: { id : menuId },
			dataType : "json"
		});

		request.done(function(msg) {
			scope.models = msg.results;
			scope.pages = msg.pages * 1;
			scope.pagesArray = new Array(scope.pages);
		});

		request.fail(function(jqXHR, textStatus) {
			alert("Request failed: " + textStatus);
		});
	},
	
	// Called when "delete" is clicked
	del: function(e, detail, sender) {
		var scope = this;
		var m = e.target.templateInstance.model.m;

		if (confirm("Are you sure?") && m.id > 0) {
			var type = "DELETE";
			var uri = "/api/v1/" + this.model + "/" + m.id;

			// post data back to server
			var request = $.ajax({
				url : uri,
				type : type,
				data: m,
				dataType : "json"
			});

			request.done(function(msg) {
				scope.loadData();
			});

			request.fail(function(jqXHR, textStatus) {
				alert("Request failed: " + textStatus);
			});
		}
	},

	cancel: function() {
		// show data table
		this.$.data_table.style.display = 'block';
		this.$.data_table.style.visibility = 'visible';
		
		// remove edit form
		this.$.model_form.innerHTML = '';
	},
	
	// Called when a create or edit form is submitted. If id > 0, then it's an edit.
	submit : function(e, detail, sender) {
		var scope = this;
		var m = e.target.templateInstance.model.m;
		this.cancel();

		var type = "PUT";
		var uri = "/api/v1/" + this.model;
		if (m.id > 0) {
			// update record
			type = "POST";
			uri = uri + "/" + m.id;
		} else {
			uri = uri + "?" + this.params;
		}

		// post data back to server
		var request = $.ajax({
			url : uri,
			type : type,
			data: m,
			dataType : "json"
		});

		request.done(function(msg) {
			scope.loadData();
		});

		request.fail(function(jqXHR, textStatus) {
			alert("Request failed: " + textStatus);
		});
	}
});
