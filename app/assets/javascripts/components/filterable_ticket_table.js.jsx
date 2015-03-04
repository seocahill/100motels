var FilterableTicketTable = React.createClass({
    render: function() {
        return (
            <div>
                <SearchBar />
                <TicketTable products={this.props.products} />
            </div>
        );
    }
});
