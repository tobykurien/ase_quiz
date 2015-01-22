Polymer({
	model : '',	// name of model in backend
	m : null,	// instance of model for binding
	models : [],	// array of models being displayed
	params: '',		// parameters to pass to REST query

	// Columns to render in list (space-separated)
	cols : "name",
	columns : function() {
		// return the columns as an array
		return this.cols.split(" ");
	},

	// external operations
	actions: "",
	operations: [],	
	
	// Called when component is ready to render
	ready : function() {
		if (this.model == '') {
			alert('Model not defined for data-table');
			return;
		}

		// load external operations
		this.operations = this.actions.split(" ");
		
		this.loadData(1);
	},

	loadForm: function() {
		// render edit form with bindings to model as "m" variable
		var editForm = this.children[0];
		var formHTML = editForm.innerHTML.replace("[[", "{{");
		formHTML = formHTML.replace("]]", "}}");
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

	operation: function(e, detail, sender) {
		var model = e.target.templateInstance.model;
		alert(model.o + " - " + model.m.id);
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
