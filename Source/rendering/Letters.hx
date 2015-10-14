package rendering;

import math.Vector3;
import rendering.Mesh;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Letters
{

	public static function convertToMesh ( string:String, gap:Float = 0.05 ):Mesh {
		var mesh:Mesh = new Mesh ();
		var currentXPos:Float = 0;
		
		for (i in 0...string.length) {
			var letterMesh:Mesh;
			var letter:String = string.charAt( i ).toLowerCase();
			switch ( letter ) {
				case "a":
					letterMesh = createA ();
				case "b":
					letterMesh = createB ();
				case "c":
					letterMesh = createC ();
				case "d":
					letterMesh = createD ();
				case "e":
					letterMesh = createE ();
				case "f":
					letterMesh = createF ();
				case "g":
					letterMesh = createG ();
				case "h":
					letterMesh = createH ();
				case "i":
					letterMesh = createI ();
				case "j":
					letterMesh = createJ ();
				case "k":
					letterMesh = createK ();
				case "l":
					letterMesh = createL ();
				case "m":
					letterMesh = createM ();
				case "n":
					letterMesh = createN ();
				case "o":
					letterMesh = createO ();
				case "p":
					letterMesh = createP ();
				case "q":
					letterMesh = createQ ();
				case "r":
					letterMesh = createR ();
				case "s":
					letterMesh = createS ();
				case "t":
					letterMesh = createT ();
				case "u":
					letterMesh = createU ();
				case "v":
					letterMesh = createV ();
				case "w":
					letterMesh = createW ();
				case "x":
					letterMesh = createX ();
				case "y":
					letterMesh = createY ();
				case "z":
					letterMesh = createZ ();
				default:
					throw "unkown character...";
			}
			
			letterMesh.relPosition = new Vector3 ( currentXPos, 0, 0 );
			currentXPos += Math.max (letterMesh.width, 0.5) + gap;
			trace (currentXPos);
			
			mesh.merge (letterMesh);
		}
		
		return mesh;
	}
	
	public static function createA ( width:Float = 0.5, height:Float = 1 ):Mesh {
		var a:Mesh = new Mesh ();
		
		//Outer Edges
		a.addVertex ( - width * 0.5, - height * 0.5, 0 );
		a.addVertex ( 0, height * 0.5, 0 );
		a.addVertex ( width * 0.5, - height * 0.5, 0 );
		
		//Inner Edge
		a.addVertex ( - width * 0.3, - height * 0.1, 0 );
		a.addVertex ( width * 0.3, - height * 0.1, 0 );
		
		a.addEdge ( 0, 1 );
		a.addEdge ( 1, 2 );
		a.addEdge ( 3, 4 );
		
		Primitives.finishMesh ( a );
		
		return a;
	}
	
	public static function createB ( width:Float = 0.5, height:Float = 1 ):Mesh {
		var b:Mesh = new Mesh ();
		
		//Tall Edge
		b.addVertex ( - width * 0.5, - height * 0.5, 0 );
		b.addVertex ( - width * 0.5, height * 0.5, 0 );
		//Mid Point
		b.addVertex ( - width * 0.5, 0, 0 );
		//right points
		b.addVertex ( width * 0.5, height * 0.25, 0 );
		b.addVertex ( width * 0.5, - height * 0.25, 0 );
		
		b.addEdge ( 0, 1 );
		b.addEdge ( 1, 3 );
		b.addEdge ( 3, 2 );
		b.addEdge ( 2, 4 );
		b.addEdge ( 4, 0 );
		
		
		Primitives.finishMesh ( b );
		
		return b;
	}
	
	public static function createC( width:Float = 0.5, height:Float = 1 ):Mesh {
		var c:Mesh = new Mesh ();
		
		//Outer Edges
		c.addVertex ( - width * 0.5, - height * 0.5, 0 );
		c.addVertex ( - width * 0.5, height * 0.5, 0 );
		c.addVertex ( width * 0.5, height * 0.5, 0 );
		c.addVertex ( width * 0.5,  - height * 0.5, 0 );
		
		c.addEdge ( 0, 1 );
		c.addEdge ( 0, 3 );
		c.addEdge ( 1, 2 );
		
		Primitives.finishMesh ( c );
		
		return c;
	}
	
	public static function createD( width:Float = 0.5, height:Float = 1 ):Mesh {
		var d:Mesh = new Mesh ();
		
		//Outer Edges
		d.addVertex ( - width * 0.5, - height * 0.5, 0 );
		d.addVertex ( - width * 0.5, height * 0.5, 0 );
		d.addVertex ( width * 0.5, height * 0.2, 0 );
		d.addVertex ( width * 0.5,  - height * 0.2, 0 );
		
		d.addEdge ( 0, 1 );
		d.addEdge ( 0, 3 );
		d.addEdge ( 1, 2 );
		d.addEdge ( 3, 2 );
		
		Primitives.finishMesh ( d );
		
		return d;
	}
	
	public static function createE( width:Float = 0.5, height:Float = 1 ):Mesh {
		var e:Mesh = new Mesh ();
		
		//Outer Edges
		e.addVertex ( - width * 0.5, - height * 0.5, 0 );
		e.addVertex ( - width * 0.5, height * 0.5, 0 );
		e.addVertex ( width * 0.5, height * 0.5, 0 );
		e.addVertex ( width * 0.5,  - height * 0.5, 0 );
		
		e.addVertex ( - width * 0.5,  0, 0 );
		e.addVertex ( width * 0.3,  0, 0 );
		
		e.addEdge ( 0, 1 );
		e.addEdge ( 0, 3 );
		e.addEdge ( 1, 2 );
		e.addEdge ( 4, 5 );
		//e.addEdge ( 3, 2 );
		
		Primitives.finishMesh ( e );
		
		return e;
	}
	
	public static function createF( width:Float = 0.5, height:Float = 1 ):Mesh {
		var f:Mesh = new Mesh ();
		
		//Outer Edges
		f.addVertex ( - width * 0.5, - height * 0.5, 0 );
		f.addVertex ( - width * 0.5, height * 0.5, 0 );
		f.addVertex ( width * 0.5, height * 0.5, 0 );

		f.addVertex ( - width * 0.5,  0, 0 );
		f.addVertex ( width * 0.3,  0, 0 );
		
		f.addEdge ( 0, 1 );
		f.addEdge ( 1, 2 );
		f.addEdge ( 3, 4 );
		
		Primitives.finishMesh ( f );
		
		return f;
	}
	
	public static function createG( width:Float = 0.5, height:Float = 1 ):Mesh {
		var g:Mesh = new Mesh ();
		
		//Outer Edges
		g.addVertex ( - width * 0.5, - height * 0.5, 0 );
		g.addVertex ( - width * 0.5, height * 0.5, 0 );
		g.addVertex ( width * 0.5, height * 0.5, 0 );
		g.addVertex ( width * 0.5,  - height * 0.5, 0 );

		g.addVertex ( width * 0.2,  - height * 0.2, 0 );
		g.addVertex ( width * 0.5,  - height * 0.2, 0 );
		
		g.addEdge ( 0, 1 );
		g.addEdge ( 1, 2 );
		g.addEdge ( 0, 3 );
		g.addEdge ( 3, 5 );
		g.addEdge ( 4, 5 );
		
		Primitives.finishMesh ( g );
		
		return g;
	}
	
	public static function createH( width:Float = 0.5, height:Float = 1 ):Mesh {
		var h:Mesh = new Mesh ();
		
		//Outer Edges
		h.addVertex ( - width * 0.5, - height * 0.5, 0 );
		h.addVertex ( - width * 0.5, height * 0.5, 0 );
		h.addVertex ( width * 0.5, height * 0.5, 0 );
		h.addVertex ( width * 0.5, - height * 0.5, 0 );

		h.addVertex ( - width * 0.5, 0, 0 );
		h.addVertex ( width * 0.5, 0, 0 );
		
		h.addEdge ( 0, 1 );
		h.addEdge ( 2, 3 );
		h.addEdge ( 4, 5 );
		
		Primitives.finishMesh ( h );
		
		return h;
	}
	
	public static function createI( width:Float = 0.5, height:Float = 1 ):Mesh {
		var i:Mesh = new Mesh ();
		
		//Outer Edges
		i.addVertex ( 0, - height * 0.5, 0 );
		i.addVertex ( 0, height * 0.35, 0 );
		
		i.addVertex ( 0, height * 0.5, 0 );
		i.addVertex ( 0, height * 0.45, 0 );
		
		i.addEdge ( 0, 1 );
		i.addEdge ( 2, 3 );
		
		Primitives.finishMesh ( i );
		
		return i;
	}
	
	public static function createJ( width:Float = 0.5, height:Float = 1 ):Mesh {
		var j:Mesh = new Mesh ();
		
		//Outer Edges
		j.addVertex ( width * 0.5, - height * 0.5, 0 );
		j.addVertex ( width * 0.5, height * 0.5, 0 );
		j.addVertex (  - width * 0.5,  - height * 0.5, 0 );
		j.addVertex (  - width * 0.5,  - height * 0.2, 0 );
		
		j.addEdge ( 0, 1 );
		j.addEdge ( 0, 2 );
		j.addEdge ( 2, 3 );
		
		Primitives.finishMesh ( j );
		
		return j;
	}
	
	public static function createK( width:Float = 0.5, height:Float = 1 ):Mesh {
		var k:Mesh = new Mesh ();
		
		//Outer Edges
		k.addVertex (  - width * 0.5, - height * 0.5, 0 );
		k.addVertex (  - width * 0.5, height * 0.5, 0 );
		k.addVertex (  width * 0.5,  - height * 0.5, 0 );
		k.addVertex (  width * 0.5,  height * 0.5, 0 );
		k.addVertex ( - width * 0.5, 0, 0 );
		
		k.addEdge ( 0, 1 );
		k.addEdge ( 2, 4 );
		k.addEdge ( 3, 4 );
		
		Primitives.finishMesh ( k );
		
		return k;
	}
	
	public static function createL( width:Float = 0.5, height:Float = 1 ):Mesh {
		var l:Mesh = new Mesh ();
		
		//Outer Edges
		l.addVertex (  - width * 0.5, - height * 0.5, 0 );
		l.addVertex (  - width * 0.5, height * 0.5, 0 );
		l.addVertex (  width * 0.5,  - height * 0.5, 0 );
		
		l.addEdge ( 0, 1 );
		l.addEdge ( 0, 2 );
		
		Primitives.finishMesh ( l );
		
		return l;
	}
	
	public static function createM( width:Float = 0.5, height:Float = 1 ):Mesh {
		var m:Mesh = new Mesh ();
		
		//Outer Edges
		m.addVertex (  - width * 0.5, - height * 0.5, 0 );
		m.addVertex (  - width * 0.5, height * 0.5, 0 );
		m.addVertex (  width * 0.5,  height * 0.5, 0 );
		m.addVertex (  width * 0.5,  - height * 0.5, 0 );
		
		m.addVertex (  0,  - height * 0.2, 0 );
		
		m.addEdge ( 0, 1 );
		m.addEdge ( 2, 3 );
		m.addEdge ( 1, 4 );
		m.addEdge ( 4, 2 );
		
		Primitives.finishMesh ( m );
		
		return m;
	}
	
	public static function createN( width:Float = 0.5, height:Float = 1 ):Mesh {
		var n:Mesh = new Mesh ();
		
		//Outer Edges
		n.addVertex (  - width * 0.5, - height * 0.5, 0 );
		n.addVertex (  - width * 0.5, height * 0.5, 0 );
		n.addVertex (  width * 0.5,  height * 0.5, 0 );
		n.addVertex (  width * 0.5,  - height * 0.5, 0 );
		
		n.addEdge ( 0, 1 );
		n.addEdge ( 2, 3 );
		n.addEdge ( 1, 3 );
		
		Primitives.finishMesh ( n );
		
		return n;
	}
	
	public static function createO( width:Float = 0.5, height:Float = 1 ):Mesh {
		var o:Mesh = new Mesh ();
		
		//Outer Edges
		o.addVertex (  - width * 0.5, - height * 0.5, 0 );
		o.addVertex (  - width * 0.5, height * 0.5, 0 );
		o.addVertex (  width * 0.5,  height * 0.5, 0 );
		o.addVertex (  width * 0.5,  - height * 0.5, 0 );
		
		o.addEdge ( 0, 1 );
		o.addEdge ( 2, 3 );
		o.addEdge ( 0, 3 );
		o.addEdge ( 1, 2 );
		
		Primitives.finishMesh ( o );
		
		return o;
	}
	
	public static function createP( width:Float = 0.5, height:Float = 1 ):Mesh {
		var p:Mesh = new Mesh ();
		
		//Outer Edges
		p.addVertex (  - width * 0.5, - height * 0.5, 0 );
		p.addVertex (  - width * 0.5, height * 0.5, 0 );
		p.addVertex (  width * 0.5,  height * 0.5, 0 );
		p.addVertex (  width * 0.5,  0, 0 );
		p.addVertex (  - width * 0.5,  0, 0 );
		
		p.addEdge ( 0, 1 );
		p.addEdge ( 2, 3 );
		p.addEdge ( 1, 2 );
		p.addEdge ( 3, 4 );
		
		Primitives.finishMesh ( p );
		
		return p;
	}
	
	public static function createQ( width:Float = 0.5, height:Float = 1 ):Mesh {
		var q:Mesh = new Mesh ();
		
		//Outer Edges
		q.addVertex (  - width * 0.5, - height * 0.5, 0 );
		q.addVertex (  - width * 0.5, height * 0.5, 0 );
		q.addVertex (  width * 0.5,  height * 0.5, 0 );
		q.addVertex (  width * 0.5,  - height * 0.5, 0 );
		q.addVertex (  width * 0.3,  - height * 0.3, 0 );
		
		q.addEdge ( 0, 1 );
		q.addEdge ( 2, 3 );
		q.addEdge ( 0, 3 );
		q.addEdge ( 1, 2 );
		q.addEdge ( 3, 4 );
		
		Primitives.finishMesh ( q );
		
		return q;
	}
	
	public static function createR( width:Float = 0.5, height:Float = 1 ):Mesh {
		var r:Mesh = new Mesh ();
		
		//Outer Edges
		r.addVertex (  - width * 0.5, - height * 0.5, 0 );
		r.addVertex (  - width * 0.5, height * 0.5, 0 );
		r.addVertex (  width * 0.5,  height * 0.5, 0 );
		r.addVertex (  width * 0.5,  0, 0 );
		r.addVertex (  - width * 0.5,  0, 0 );
		r.addVertex (  width * 0.5,   - height * 0.5, 0 );
		
		r.addEdge ( 0, 1 );
		r.addEdge ( 2, 3 );
		r.addEdge ( 1, 2 );
		r.addEdge ( 3, 4 );
		r.addEdge ( 4, 5 );
		
		Primitives.finishMesh ( r );
		
		return r;
	}
	
	public static function createS( width:Float = 0.5, height:Float = 1 ):Mesh {
		var s:Mesh = new Mesh ();
		
		//Outer Edges
		s.addVertex (  - width * 0.5, - height * 0.5, 0 );
		s.addVertex (  width * 0.5, - height * 0.5, 0 );
		s.addVertex (  width * 0.5, 0, 0 );
		s.addVertex (  - width * 0.5, 0, 0 );
		s.addVertex (  - width * 0.5, height * 0.5, 0 );
		s.addVertex (  width * 0.5, height * 0.5, 0 );
		
		s.addEdge ( 0, 1 );
		s.addEdge ( 1, 2 );
		s.addEdge ( 2, 3 );
		s.addEdge ( 3, 4 );
		s.addEdge ( 4, 5 );
		
		Primitives.finishMesh ( s );
		
		return s;
	}
	
	public static function createT( width:Float = 0.5, height:Float = 1 ):Mesh {
		var t:Mesh = new Mesh ();
		
		//Outer Edges
		t.addVertex ( 0, - height * 0.5, 0 );
		t.addVertex ( 0, height * 0.5, 0 );
		t.addVertex ( - width * 0.5, height * 0.5, 0 );
		t.addVertex ( width * 0.5, height * 0.5, 0 );
		
		t.addEdge ( 0, 1 );
		t.addEdge ( 2, 3 );
		
		Primitives.finishMesh ( t );
		
		return t;
	}
	
	public static function createU( width:Float = 0.5, height:Float = 1 ):Mesh {
		var u:Mesh = new Mesh ();
		
		//Outer Edges
		u.addVertex ( - width * 0.5, - height * 0.5, 0 );
		u.addVertex ( - width * 0.5, height * 0.5, 0 );
		u.addVertex ( width * 0.5, - height * 0.5, 0 );
		u.addVertex ( width * 0.5, height * 0.5, 0 );
		
		u.addEdge ( 0, 1 );
		u.addEdge ( 0, 2 );
		u.addEdge ( 2, 3 );
		
		Primitives.finishMesh ( u );
		
		return u;
	}
	
	public static function createV( width:Float = 0.5, height:Float = 1 ):Mesh {
		var v:Mesh = new Mesh ();
		
		//Outer Edges
		v.addVertex ( 0, - height * 0.5, 0 );
		v.addVertex ( - width * 0.5, height * 0.5, 0 );
		v.addVertex ( width * 0.5, height * 0.5, 0 );
		
		v.addEdge ( 0, 1 );
		v.addEdge ( 0, 2 );
		
		Primitives.finishMesh ( v );
		
		return v;
	}
	
	public static function createW( width:Float = 0.5, height:Float = 1 ):Mesh {
		var w:Mesh = new Mesh ();
		
		//Outer Edges
		w.addVertex (  - width * 0.5, - height * 0.5, 0 );
		w.addVertex (  - width * 0.5, height * 0.5, 0 );
		w.addVertex (  width * 0.5,  height * 0.5, 0 );
		w.addVertex (  width * 0.5,  - height * 0.5, 0 );
		
		w.addVertex (  0,  height * 0.2, 0 );
		
		w.addEdge ( 0, 1 );
		w.addEdge ( 2, 3 );
		w.addEdge ( 0, 4 );
		w.addEdge ( 4, 3 );
		
		Primitives.finishMesh ( w );
		
		return w;
	}
	
	public static function createX( width:Float = 0.5, height:Float = 1 ):Mesh {
		var x:Mesh = new Mesh ();
		
		//Outer Edges
		x.addVertex ( - width * 0.5, - height * 0.5, 0 );
		x.addVertex ( width * 0.5, height * 0.5, 0 );
		x.addVertex ( - width * 0.5, height * 0.5, 0 );
		x.addVertex ( width * 0.5, - height * 0.5, 0 );
		
		x.addEdge ( 0, 1 );
		x.addEdge ( 2, 3 );
		
		Primitives.finishMesh ( x );
		
		return x;
	}
	
	public static function createY( width:Float = 0.5, height:Float = 1 ):Mesh {
		var y:Mesh = new Mesh ();
		
		//Outer Edges
		y.addVertex ( 0, - height * 0.5, 0 );
		y.addVertex ( 0, 0, 0 );
		y.addVertex ( - width * 0.5, height * 0.5, 0 );
		y.addVertex ( width * 0.5, height * 0.5, 0 );
		
		y.addEdge ( 0, 1 );
		y.addEdge ( 1, 2 );
		y.addEdge ( 1, 3 );
		
		Primitives.finishMesh ( y );
		
		return y;
	}
	
	public static function createZ( width:Float = 0.5, height:Float = 1 ):Mesh {
		var z:Mesh = new Mesh ();
		
		//Outer Edges
		z.addVertex (  - width * 0.5, - height * 0.5, 0 );
		z.addVertex (  width * 0.5, - height * 0.5, 0 );
		z.addVertex (  - width * 0.5, height * 0.5, 0 );
		z.addVertex (  width * 0.5, height * 0.5, 0 );
		
		z.addEdge ( 0, 1 );
		z.addEdge ( 2, 3 );
		z.addEdge ( 3, 0 );
		
		Primitives.finishMesh ( z );
		
		return z;
	}
}