if (Meteor.isClient) {
    Meteor.subscribe('books');
    var BooksCollection = new Meteor.Collection('books');

    Session.setDefault('counter', 0);

    Template.hello.helpers({
        book: function () {
            return BooksCollection.find().fetch();
        }
    });

    Template.displayBook.events({
        'click .remove': function(event, template) {
            var bookid = template.find('.bookid').childNodes[0].textContent;
            BooksCollection.remove({_id: bookid});
            return false;
        }
    });
}

if (Meteor.isServer) {

    var BooksCollection = new Meteor.Collection('books', {
        idGeneration: 'MONGO'
    });
    
    Meteor.publish('books', function() {
        return BooksCollection.find();   
    })
    Meteor.startup(function () {
        // code to run on server at startup
    });


}