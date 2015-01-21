 Polymer({
   model: '',
   m: null,
   
   models: [],

   cols: "name",
   columns: function() {
      return this.cols.split(" ");
   },

   editCols: "name",
   editColumns: function() {
      return this.editCols.split(" ");
   },
   
   ready: function() {
      if (this.model == '') {
         alert('Model not defined for data-table');
         return;
      }

      this.loadData(1);
   },
   
   edit: function(e, detail, sender) {
     var m = e.target.templateInstance.model.m;
     this.m = m;

     var formHTML = this.innerHTML.replace("[[", "{{");
     formHTML = formHTML.replace("]]", "}}");
     this.injectBoundHTML(formHTML, this.$.model_form);          
   },
   
   loadPage: function(e, detail, sender) {
     var p = e.target.templateInstance.model.pIndex + 1;
     this.loadData(p);
   },
   
   previousPage: function() {
      if (this.page > 1) {
         this.page = this.page - 1;
         this.loadData(this.page);
      }
   },
   
   nextPage: function() {
      if (this.page < this.pages) {
         this.page = this.page + 1;
         this.loadData(this.page);
      }
   },
   
   loadData: function(page) {
      scope = this;
      this.page = page;
      
      // load data
      var request = $.ajax({
         url: "/api/v1/" + this.model + "?page=" + page,
         type: "GET",
         //data: { id : menuId },
         dataType: "json"
      });
   
      request.done(function( msg ) {
         scope.models = msg.results;
         scope.pages = msg.pages * 1;
         scope.pagesArray = new Array(scope.pages);
      });
   
      request.fail(function( jqXHR, textStatus ) {
         alert( "Request failed: " + textStatus );
      });            
   }
 });

