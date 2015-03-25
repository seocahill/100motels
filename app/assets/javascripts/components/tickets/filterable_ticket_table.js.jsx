var FilterableTicketTable = React.createClass({
    getInitialState: function() {
        return {
            filterText: '',
            isAdmitted: false
        };
    },

    handleUserInput: function(filterText, isAdmitted) {
        this.setState({
            filterText: filterText,
            isAdmitted: isAdmitted
        });
    },

    render: function() {
        return (
            <div>
                <SearchBar
                    filterText={this.state.filterText}
                    isAdmitted={this.state.isAdmitted}
                    onUserInput={this.handleUserInput}
                />
                <TicketTable
                    tickets={this.props.tickets}
                    filterText={this.state.filterText}
                    isAdmitted={this.state.isAdmitted}
                />
            </div>
        );
    }
});
