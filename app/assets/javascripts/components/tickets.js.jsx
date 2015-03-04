var Tickets = React.createClass({
  propTypes: {
    number: React.PropTypes.string,
    admitted: React.PropTypes.node,
    orderId: React.PropTypes.string
  },

  render: function() {
    return (
      <div>
        <div>Number: {this.props.number}</div>
        <div>Admitted: {this.props.admitted}</div>
        <div>Order: {this.props.order_id}</div>
      </div>
    );
  }
});
