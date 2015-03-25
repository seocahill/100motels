var About = React.createClass({
    render: function() {
      return (
          <div><div dangerouslySetInnerHTML={{__html: this.props.about}}/></div>
        );
      }
  });
