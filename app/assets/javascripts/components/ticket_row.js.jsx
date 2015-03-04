var TicketRow = React.createClass({
    render: function() {
        var number = this.props.ticket.admitted ?
            this.props.ticket.number :
            <span style={{color: 'red'}}>
                {this.props.ticket.number}
            </span>;
        return (
            <tr>
                <td>{number}</td>
                <td>{this.props.ticket.order_id}</td>
            </tr>
        );
    }
});
