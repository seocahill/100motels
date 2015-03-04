var TicketTable = React.createClass({
    render: function() {
        console.log(this.props);
        var rows = [];
        this.props.tickets.forEach(function(ticket) {
          if (ticket.number.indexOf(this.props.filterText) === -1 || (!ticket.admitted && this.props.isAdmitted)) {
              return;
          }
          rows.push(<TicketRow ticket={ticket} key={ticket.number} />);
        }.bind(this));
        return (
            <table className="table table-bordered">
                <thead>
                    <tr>
                        <th>Number</th>
                        <th>Order id</th>
                    </tr>
                </thead>
                <tbody>{rows}</tbody>
            </table>
        );
    }
});
