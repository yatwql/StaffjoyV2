import _ from 'lodash';
import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

require('./table-header.scss');

function TableHeader({ columns }) {
  return (
    <thead>
      <tr>
        {
          _.map(columns, (column) => {
            const classes = classNames({
              'mdl-data-table__cell--non-numeric': true,
              [`col-${column.colWidth}`]: true,
            });
            const key = `col-header-${column.columnId}`;

            return (
              <th key={key} className={classes}>
                {column.displayName}
              </th>);
          })
        }
      </tr>
    </thead>
  );
}

TableHeader.propTypes = {
  columns: PropTypes.arrayOf(PropTypes.object).isRequired,
};

export default TableHeader;
