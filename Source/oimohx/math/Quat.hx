/* Copyright (c) 2012-2013 EL-EMENT saharan
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation  * files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy,  * modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package oimohx.math;

import oimohx.math.Vec3;

/**
 * A quaternion. This is used to represent three-dimansional orientations of rigid bodies.
 * @author saharan
 */
class Quat { 
	
    public var s:Float;
    public var x:Float;
    public var y:Float;
    public var z:Float;
    
    /**
	 * Constructor.
	 * If the parameters are empty, the quaternion will be set to the identity quaternion.
	 * @param	s
	 * @param	x
	 * @param	y
	 * @param	z
	 */
    public function new(s:Float = 1, x:Float = 0, y:Float = 0, z:Float = 0) {
        this.s = s;
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    /**
	 * Initialize the quaternion.
	 * If the parameters are empty, the quaternion will be set to the identity quaternion.
	 * @param	s
	 * @param	x
	 * @param	y
	 * @param	z
	 * @return
	 */
    public function init(s:Float = 1, x:Float = 0, y:Float = 0, z:Float = 0):Quat {
        this.s = s;
        this.x = x;
        this.y = y;
        this.z = z;
        return this;
    }
    
    /**
	 * this = q1 + q2
	 * @param	q1
	 * @param	q2
	 * @return
	 */
    inline public function add(q1:Quat, q2:Quat):Quat {
        s = q1.s + q2.s;
        x = q1.x + q2.x;
        y = q1.y + q2.y;
        z = q1.z + q2.z;
        return this;
    }
	
	inline public function addTime(v:Vec3, t:Float):Quat {
        var x = v.x;
        var y = v.y;
        var z = v.z;
		
        var qs = this.s;
        var qx = this.x;
        var qy = this.y;
        var qz = this.z;
		
        t *= 0.5;
        var ns = ( -x * qx - y * qy - z * qz) * t;
        var nx = ( x * qs + y * qz - z * qy) * t;
        var ny = ( -x * qz + y * qs + z * qx) * t;
        var nz = ( x * qy - y * qx + z * qs) * t;
		
        qs += ns;
        qx += nx;
        qy += ny;
        qz += nz;
		
        var s = 1 / Math.sqrt(qs * qs + qx * qx + qy * qy + qz * qz);
		
        this.s = qs * s;
        this.x = qx * s;
        this.y = qy * s;
        this.z = qz * s;
		
        return this;
    }
    
    /**
	 * this = q1 - q2
	 * @param	q1
	 * @param	q2
	 * @return
	 */
    inline public function sub(q1:Quat, q2:Quat):Quat {
        s = q1.s - q2.s;
        x = q1.x - q2.x;
        y = q1.y - q2.y;
        z = q1.z - q2.z;
        return this;
    }
    
    /**
	 * this = q * s
	 * @param	q
	 * @param	s
	 * @return
	 */
    inline public function scale(q:Quat, s:Float):Quat {
        this.s = q.s * s;
        x = q.x * s;
        y = q.y * s;
        z = q.z * s;
        return this;
    }
    
    /**
	 * this = q1 * q2
	 * @param	q1
	 * @param	q2
	 * @return
	 */
    inline public function mul(q1:Quat, q2:Quat):Quat {
        this.s = q1.s * q2.s - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
        this.x = q1.s * q2.x + q1.x * q2.s + q1.y * q2.z - q1.z * q2.y;
        this.y = q1.s * q2.y - q1.x * q2.z + q1.y * q2.s + q1.z * q2.x;
        this.z = q1.s * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.s;
        return this;
    }
    
    /**
	 * Set this quaternion to the shortest arc rotation quaternion.
	 * Note that v1 and v2 must be normalized.
	 * @param	v1 from
	 * @param	v2 to
	 * @return
	 */
    public function arc(v1:Vec3, v2:Vec3):Quat {
        var d:Float = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;  // cos(theta)  
        if (d == -1) {  // 180 rotation, set a vector perpendicular to v1  
            v2.x = v1.y * v1.x - v1.z * v1.z;
            v2.y = -v1.z * v1.y - v1.x * v1.x;
            v2.z = v1.x * v1.z + v1.y * v1.y;
            d = 1 / Math.sqrt(v2.x * v2.x + v2.y * v2.y + v2.z * v2.z);
            s = 0;
            x = v2.x * d;
            y = v2.y * d;
            z = v2.z * d;
        } 
		else {
			d = 0.5 / Math.sqrt((1 + d) * 0.5);  // sin(theta / 2) / sin(theta)  
			x = (v1.y * v2.z - v1.z * v2.y) * d;
			y = (v1.z * v2.x - v1.x * v2.z) * d;
			z = (v1.x * v2.y - v1.y * v2.x) * d;
		}
        return this;
    }
    
    /**
	 * Set this quaternion to the normalized quaternion of q.
	 * @param	q
	 * @return
	 */
    inline public function normalize(q:Quat):Quat {
        var len:Float = Math.sqrt(q.s * q.s + q.x * q.x + q.y * q.y + q.z * q.z);
        if (len > 0) {
			len = 1 / len;
		}
        s = q.s * len;
        x = q.x * len;
        y = q.y * len;
        z = q.z * len;
        return this;
    }
    
    /**
	 * this = -q
	 * @param	q
	 * @return
	 */
    inline public function invert(q:Quat):Quat {
        s = q.s;
        x = -q.x;
        y = -q.y;
        z = -q.z;
        return this;
    }
    
    /**
	 * Get the length of the quaternion.
	 * @return
	 */
    inline public function length():Float {
        return Math.sqrt(s * s + x * x + y * y + z * z);
    }
    
    /**
	 * this = q
	 * @param	q
	 * @return
	 */
    inline public function copy(q:Quat):Quat {
        s = q.s;
        x = q.x;
        y = q.y;
        z = q.z;
        return this;
    }
	
	inline public function testDiff(q:Quat):Bool {
        if (this.s != q.s || this.x != q.x || this.y != q.y || this.z != q.z) {
			return true;
		}
        else {
			return false;
		}
    }
    
    /**
	 * Get the clone of the quaternion.
	 * @return
	 */
    inline public function clone(q:Quat):Quat {
        return new Quat(s, x, y, z);
    }
    
    /**
	 * Get the string of the quaternion.
	 * @return
	 */
    public function toString():String {
        return "Quat[" + s + ", (" + x + ", " + y + ", " + z + ")]";
    }
	
}
