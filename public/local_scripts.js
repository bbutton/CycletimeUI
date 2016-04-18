/**
 * Created by bbutton on 4/13/16.
 */

"use strict";

var _ = require('lodash');

function collectCycleTimesAsArray(cycleTimes) {
    //var cycleTimeValues = _.map(cycleTimes, function(cycletimeData) { return cycletimeData[:cycle_time]; });
    //return cycleTimeValues;
    return [10, 11, 12, 13, 14, 15];
}

function collectSampleIndices(cycleTimes) {
    //return _.range(cycleTimes);
    return _.range(6);
}
