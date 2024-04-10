export const bezier = {

  min(out, v1, v2) {
    out[0] = Math.min(v1[0], v2[0]);
    out[1] = Math.min(v1[1], v2[1]);
    return out;
  },
  max(out, v1, v2) {
    out[0] = Math.max(v1[0], v2[0]);
    out[1] = Math.max(v1[1], v2[1]);
    return out;
  },
  add(out, v1, v2) {
    out[0] = v1[0] + v2[0];
    out[1] = v1[1] + v2[1];
    return out;
  },
  sub(out, v1, v2) {
    out[0] = v1[0] - v2[0];
    out[1] = v1[1] - v2[1];
    return out;
  },
  scale(out, v, s) {
    out[0] = v[0] * s;
    out[1] = v[1] * s;
    return out;
  },
  distance(v1, v2) {
    var x = v2[0] - v1[0];
    var y = v2[1] - v1[1];
    return Math.sqrt(x * x + y * y);
  },

  getPoint(v) {
    return [v.x, v.y];
  },
  smoothBezier(points, smooth, isLoop, constraint) {
    var cps = [];
    var prevPoint;
    var nextPoint;
    var hasConstraint = !!constraint;
    var min;
    var max;
    var point;
    var len;
    var l;
    var i;
    if (hasConstraint) {
      min = [Infinity, Infinity];
      max = [-Infinity, -Infinity];
      for (i = 0, l = points.length; i < l; i++) {
        point = this.getPoint(points[i]);
        this.min(min, min, point);
        this.max(max, max, point);
      }
      this.min(min, min, constraint[0]);
      this.max(max, max, constraint[1]);
    }
    for (i = 0, len = points.length; i < len; i++) {
      point = this.getPoint(points[i]);
      if (isLoop) {
        prevPoint = this.getPoint(points[i ? i - 1 : len - 1]);
        nextPoint = this.getPoint(points[(i + 1) % len]);
      } else {
        if (i === 0 || i === len - 1) {
          cps.push([point[0], point[1]]);
          continue;
        } else {
          prevPoint = this.getPoint(points[i - 1]);
          nextPoint = this.getPoint(points[i + 1]);
        }
      }
      var v = this.sub([], nextPoint, prevPoint);
      this.scale(v, v, smooth);
      var d0 = this.distance(point, prevPoint);
      var d1 = this.distance(point, nextPoint);
      var sum = d0 + d1;
      if (sum !== 0) {
        d0 /= sum;
        d1 /= sum;
      }
      var v1 = this.scale([], v, -d0);
      var v2 = this.scale([], v, d1);
      var cp0 = this.add([], point, v1);
      var cp1 = this.add([], point, v2);
      if (hasConstraint) {
        this.max(cp0, cp0, min);
        this.min(cp0, cp0, max);
        this.max(cp1, cp1, min);
        this.min(cp1, cp1, max);
      }
      cps.push([cp0[0], cp0[1]]);
      cps.push([cp1[0], cp1[1]]);
    }
    if (isLoop) {
      cps.push(cps.shift());
    }
    return cps;
  },

  catmullRom2bezier(pointList, z, constraint) {
    var isLoop = !!z;
    var controlPointList = this.smoothBezier(pointList, 0.4, isLoop, constraint);
    var len = pointList.length;
    var d1 = [];
    var cp1;
    var cp2;
    var p;
    for (var i = 0; i < len - 1; i++) {
      cp1 = controlPointList[i * 2];
      cp2 = controlPointList[i * 2 + 1];
      p = pointList[i + 1];
      d1.push(['C', cp1[0], cp1[1], cp2[0], cp2[1], p.x, p.y]);
    }
    if (isLoop) {
      cp1 = controlPointList[len];
      cp2 = controlPointList[len + 1];
      p = pointList[0];
      d1.push(['C', cp1[0], cp1[1], cp2[0], cp2[1], p.x, p.y]);
    }
    return d1;
  }
}