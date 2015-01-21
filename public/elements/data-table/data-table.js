Polymer({
	model : '',
	m : null,

	models : [],

	cols : "name",
	columns : function() {
		return this.cols.split(" ");
	},

	editCols : "name",
	editColumns : function() {
		return this.editCols.split(" ");
	},

	ready : function() {
		if (this.model == '') {
			alert('Model not defined for data-table');
			return;
		}

		this.loadData(1);
	},

	edit : function(e, detail, sender) {
		var m = e.target.templateInstance.model.m;
		this.m = m;

		var formHTML = this.innerHTML.replace("[[", "{{");
		formHTML = formHTML.replace("]]", "}}");
		this.injectBoundHTML(formHTML, this.$.model_form);
	},
	
	create: function() {
		this.m = {};

		var formHTML = this.innerHTML.replace("[[", "{{");
		formHTML = formHTML.replace("]]", "}}");
		this.injectBoundHTML(formHTML, this.$.model_form);
	},

	loadPage : function(e, detail, sender) {
		var p = e.target.templateInstance.model.pIndex + 1;
		this.loadData(p);
	},

	previousPage : function() {
		if (this.page > 1) {
			this.page = this.page - 1;
			this.loadData(this.page);
		}
	},

	nextPage : function() {
		if (this.page < this.pages) {
			this.page = this.page + 1;
			this.loadData(this.page);
		}
	},

	loadData : function(page) {
		scope = this;
		
		if (page) {
			this.page = page;
		}

		// load data
		var request = $.ajax({
			url : "/api/v1/" + this.model + "?page=" + this.page,
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
	
	del: function(e, detail, sender) {
		var scope = this;
		var m = e.target.templateInstance.model.m;

		if (m.id > 0) {
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
	
	submit : function(e, detail, sender) {
		var scope = this;
		var m = e.target.templateInstance.model.m;
		this.$.model_form.innerHTML = '';

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
