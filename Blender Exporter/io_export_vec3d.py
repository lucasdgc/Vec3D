bl_info = {
    "name": "Vec3D Model Exporter",
    "author": "Lucas Gonçalves",
    "version": (0, 0, 1),
    "blender": (2, 67, 0),
    "location": "File > Export > Vec3D Model (.vec3d)",
    "description": "Export Vec3D Models (.vec3d)",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Import-Export"}
    
import math
import os
import bpy
import string
import bpy_extras.io_utils
from bpy.props import *
import mathutils, math
import struct
import shutil
from os import remove
from bpy_extras.io_utils import (ExportHelper, axis_conversion)
from bpy.props import (BoolProperty, FloatProperty, StringProperty, EnumProperty, FloatVectorProperty)

class SubMesh:
	materialIndex = 0
	verticesStart = 0
	verticesCount = 0
	indexStart = 0
	indexCount = 0
	edgesStart = 0
	edgesCount = 0
	
class MultiMaterial:
	name = ""
	materials = []

class Export_babylon(bpy.types.Operator, ExportHelper):  
	"""Export Vec3D Model (.vec3D)""" 
	bl_idname = "model.vec3d"
	bl_label = "Export Vec3d Model"

	filename_ext = ".vec3d"
	filepath = ""
	
	# global_scale = FloatProperty(name="Scale", min=0.01, max=1000.0, default=1.0)

	def execute(self, context):
	       return Export_babylon.save(self, context, **self.as_keywords(ignore=("check_existing", "filter_glob", "global_scale")))
		   
	def mesh_triangulate(mesh):
		import bmesh
		bm = bmesh.new()
		bm.from_mesh(mesh)
		bmesh.ops.triangulate(bm, faces=bm.faces)
		bm.to_mesh(mesh)
		mesh.calc_tessface()
		bm.free()

	def write_array3(file_handler, name, array):
		file_handler.write(",\""+name+"\":[" + "%.4f,%.4f,%.4f"%(array[0],array[1],array[2]) + "]")		
	
	def write_color(file_handler, name, color):
		file_handler.write(",\""+name+"\":[" + "%.4f,%.4f,%.4f"%(color.r,color.g,color.b) + "]")

	def write_vector(file_handler, name, vector):
		file_handler.write(",\""+name+"\":[" + "%.4f,%.4f,%.4f"%(vector.x,vector.z,vector.y) + "]")
	
	def write_string(file_handler, name, string, noComma=False):
		if noComma == False:
			file_handler.write(",")
		file_handler.write("\""+name+"\":\"" + string + "\"")
	
	def write_float(file_handler, name, float):
		file_handler.write(",\""+name+"\":" + "%.4f"%(float))
		
	def write_int(file_handler, name, int, noComma=False):
		if noComma == False:
			file_handler.write(",")
		file_handler.write("\""+name+"\":" + str(int))
		
	def write_bool(file_handler, name, bool):	
		if bool:
			file_handler.write(",\""+name+"\":" + "true")
		else:
			file_handler.write(",\""+name+"\":" + "false")
			
	def export_camera(object, scene, file_handler):		
		invWorld = object.matrix_world.copy()
		invWorld.invert()
		
		target = mathutils.Vector((0, 1, 0)) * invWorld
	
		file_handler.write("{")
		Export_babylon.write_string(file_handler, "name", object.name, True)		
		Export_babylon.write_string(file_handler, "id", object.name)
		Export_babylon.write_vector(file_handler, "position", object.location)
		Export_babylon.write_vector(file_handler, "target", target)
		file_handler.write("}")
		
	def export_light(object, scene, file_handler):		
		file_handler.write("{")
		Export_babylon.write_string(file_handler, "name", object.name, True)		
		Export_babylon.write_string(file_handler, "id", object.name)		
		Export_babylon.write_float(file_handler, "type", 0)
		Export_babylon.write_vector(file_handler, "data", object.location)
		Export_babylon.write_float(file_handler, "intensity", object.data.energy)
		if object.data.use_diffuse:
			Export_babylon.write_color(file_handler, "diffuse", object.data.color)
		else:
			Export_babylon.write_color(file_handler, "diffuse", mathutils.Color((0, 0, 0)))

		if object.data.use_specular:
			Export_babylon.write_color(file_handler, "specular", object.data.color)
		else:
			Export_babylon.write_color(file_handler, "specular", mathutils.Color((0, 0, 0)))
			
		file_handler.write("}")		
	
	def export_texture(slot, level, texture, scene, file_handler, filepath):	
		# Copy image to output
		try:
			image = texture.texture.image
			imageFilepath = os.path.normpath(bpy.path.abspath(image.filepath))
			basename = os.path.basename(imageFilepath)
			targetdir = os.path.dirname(filepath)
			targetpath = os.path.join(targetdir, basename)
			
			if image.packed_file:
				image.save_render(targetpath)
			else:
				sourcepath = bpy.path.abspath(image.filepath)
				shutil.copy(sourcepath, targetdir)
		except:
			pass
		
		# Export
		file_handler.write(",\""+slot+"\":{")
		Export_babylon.write_string(file_handler, "name", basename, True)
		Export_babylon.write_float(file_handler, "level", level)
		Export_babylon.write_float(file_handler, "hasAlpha", texture.texture.use_alpha)
		
		coordinatesMode = 0;
		if (texture.mapping == "CUBE"):
			coordinatesMode = 3;
		if (texture.mapping == "SPHERE"):
			coordinatesMode = 1;		
		Export_babylon.write_int(file_handler, "coordinatesMode", coordinatesMode)
		Export_babylon.write_float(file_handler, "uOffset", texture.offset.x)
		Export_babylon.write_float(file_handler, "vOffset", texture.offset.y)
		Export_babylon.write_float(file_handler, "uScale", texture.scale.x)
		Export_babylon.write_float(file_handler, "vScale", texture.scale.y)
		Export_babylon.write_float(file_handler, "uAng", 0)
		Export_babylon.write_float(file_handler, "vAng", 0)		
		Export_babylon.write_float(file_handler, "wAng", 0)
		
		if (texture.texture.extension == "REPEAT"):
			Export_babylon.write_bool(file_handler, "wrapU", True)		
			Export_babylon.write_bool(file_handler, "wrapV", True)
		else:
			Export_babylon.write_bool(file_handler, "wrapU", False)		
			Export_babylon.write_bool(file_handler, "wrapV", False)
			
		Export_babylon.write_int(file_handler, "coordinatesIndex", 0)
		
		file_handler.write("}")	
		
	def export_material(material, scene, file_handler, filepath):		
		file_handler.write("{")
		Export_babylon.write_string(file_handler, "name", material.name, True)		
		Export_babylon.write_string(file_handler, "id", material.name)
		#Export_babylon.write_color(file_handler, "ambient", material.ambient * material.diffuse_color)
		Export_babylon.write_color(file_handler, "diffuse", material.diffuse_intensity * material.diffuse_color)
		#Export_babylon.write_color(file_handler, "specular", material.specular_intensity * material.specular_color)
		#Export_babylon.write_float(file_handler, "specularPower", material.specular_hardness)
		Export_babylon.write_color(file_handler, "emissive", material.emit * material.diffuse_color)		
		Export_babylon.write_float(file_handler, "alpha", material.alpha)
		Export_babylon.write_bool(file_handler, "backFaceCulling", material.game_settings.use_backface_culling)				
		
		file_handler.write("}")			
	
	def export_multimaterial(multimaterial, scene, file_handler):		
		file_handler.write("{")
		Export_babylon.write_string(file_handler, "name", multimaterial.name, True)
		Export_babylon.write_string(file_handler, "id", multimaterial.name)
		
		file_handler.write(",\"materials\":[")
		first = True
		for materialName in multimaterial.materials:
			if first != True:
				file_handler.write(",")
			file_handler.write("\"" + materialName +"\"")
			first = False
		file_handler.write("]")
		file_handler.write("}")
	
	def export_mesh(object, scene, file_handler, multiMaterials):
		# Get mesh	
		mesh = object.to_mesh(scene, True, "PREVIEW")
		
		# Transform
		matrix_world = object.matrix_world.copy()
		matrix_world.translation = mathutils.Vector((0, 0, 0))
		mesh.transform(matrix_world)		
								
		# Triangulate mesh if required
		Export_babylon.mesh_triangulate(mesh)
		
		# Getting vertices, faces and edges
		vertices=",\"vertices\":["
		faces =",\"faces\":["	
		edges=",\"edges\":["
		vertexGroups = ",\"vertexGroups\":["
		hasUV = False;
		hasUV2 = False;
		
		
		if len(mesh.tessface_uv_textures) > 0:
		#	UVmap=mesh.tessface_uv_textures[0].data	
			hasUV = True
		else:
			hasUV = False
			
		#if len(mesh.tessface_uv_textures) > 1:
		#	UV2map=mesh.tessface_uv_textures[1].data
		#else:
		#	hasUV2 = False
			
		alreadySavedVertices = []
		vertices_UVs=[]
		vertices_UV2s=[]
		vertices_indices=[]
		subMeshes = []
		
		alreadySavedGroups = []
		#groups_indices=[]
		groupsCount = 0
		savedGroupData = []
		
		for v in range(0, len(mesh.vertices)):
			alreadySavedVertices.append(False)
			vertices_UVs.append([])
			vertices_UV2s.append([])
			vertices_indices.append([])
		
		
		for g in range(0, len(object.vertex_groups)):
			alreadySavedGroups.append(False)
			#groups_indices.append([])
			savedGroupData.append([])
		
		materialsCount = max(1, len(object.material_slots))
		verticesCount = 0
		indicesCount = 0
		edgesCount = 0
		vertsCount = 0
		
		for verts in mesh.vertices:
			
			vertex_index = vertsCount
			vertex = mesh.vertices[vertex_index]
			position = vertex.co
			normal = vertex.normal	
		
			index=vertsCount
			alreadySavedVertices[vertex_index]=True
			vertices_indices[vertex_index].append(index)
			
			vertices+="%.4f,%.4f,%.4f,"%(position.x,position.z,position.y)
			vertices+="%.4f,%.4f,%.4f,"%(normal.x,normal.z,normal.y)
			
			hasUV = len(mesh.tessface_uv_textures) > 0
			if hasUV:
				savedUV = False
				for face in mesh.tessfaces:
					for v in range (0, 3):
						if (face.vertices[v] == vertex_index):
							savedUV = True
							UVmap = mesh.tessface_uv_textures[0].data
							vertex_UV = UVmap[face.index].uv[v]
							vertices+="%.4f,%.4f,"%(vertex_UV[0], vertex_UV[1])
							break
					if (savedUV):
						break
			#if hasUV2:
			#	vertices+="%.4f,%.4f,"%(vertex_UV2[0], vertex_UV2[1])
			
			
			for vg in verts.groups:
			
				group_index = vg.group
				alreadySaved = alreadySavedGroups[group_index]
			
				print("alreadySaved: "+str(alreadySaved));
			
				if(alreadySaved):
					savedGroupData[group_index].append(index)
				else:
					alreadySavedGroups[group_index] = True
					#if len(savedGroupData) > 1:
					#	savedGroupData.append(group_index)
					savedGroupData[group_index].append(index)
					
			# vertices+="%.4f,%.4f,%.4f,"%(normal.x,normal.z,normal.y)
			#if hasUV:
			#	vertices+="%.4f,%.4f,"%(vertex_UV[0], vertex_UV[1])
				
			#if hasUV2:
			#	vertices+="%.4f,%.4f,"%(vertex_UV2[0], vertex_UV2[1])
			
			vertsCount += 1
			
		groups_count = 0
		for vGroup in savedGroupData:
		
			group_index = groups_count
			group = savedGroupData[group_index]
			
			print("groups_index: "+str(group_index));
			
			vertexGroups += "{\"id\": "+str(group_index)+",";
			vertexGroups += "\"name\": \""+object.vertex_groups[group_index].name+"\",";
			#vertexGroups += "\"array_size\": \""+str(len(savedGroupData))+"\",";
			vertexGroups += "\"items\": [";
			
			for groupItem in group:
				vertexGroups += str(groupItem) + ",";
			
			vertexGroups = vertexGroups.rstrip(',');
			vertexGroups += "]"
			
			#itemList = vGroup.data.vertices;
			
			#for item in itemList:
			#	vertexGroups += item.name;
			vertexGroups += "},";
			groups_count += 1
			
		vertexGroups = vertexGroups.rstrip(',');
		vertexGroups+="]"
			
		for edge in mesh.edges:
		
			#if edge.material_index != materialIndex:
			#	continue
	
			for v in range (2):
			
				vertex_index = edge.vertices[v]
				alreadySaved = alreadySavedVertices[vertex_index]
				index_UV = 0
				if alreadySaved:
					alreadySaved=False						
					
					for savedIndex in vertices_indices[vertex_index]:
						if savedIndex >= verticesCount:
							alreadySaved=True
							break
						index_UV+=1
				  
				if (alreadySaved):
					# Reuse vertex
					index=vertices_indices[vertex_index][index_UV]
				
				edges +="%i,"%(index)
				edgesCount += 1	
		
		for materialIndex in range(materialsCount):
			subMeshes.append(SubMesh())
			subMeshes[materialIndex].materialIndex = materialIndex
			subMeshes[materialIndex].verticesStart = verticesCount
			subMeshes[materialIndex].indexStart = indicesCount
			subMeshes[materialIndex].edgesStart = edgesCount
		
			for face in mesh.tessfaces:  # For each face
				
				if face.material_index != materialIndex:
					continue
				
				for v in range(3): # For each vertex in face
					vertex_index = face.vertices[v]
					#vertex = mesh.vertices[vertex_index]
					#position = vertex.co
					#normal = vertex.normal	
					
					#if hasUV:
					#	vertex_UV = UVmap[face.index].uv[v]
						
					#if hasUV2:
					#	vertex_UV2 = UV2map[face.index].uv[v]
						
					# Check if the current vertex is already saved					
					alreadySaved = alreadySavedVertices[vertex_index]
					index_UV = 0
					if alreadySaved:
						alreadySaved=False						
						verticesCount +=1
						# if hasUV:
						#	for vUV in vertices_UVs[vertex_index]:
						#		if (vUV[0]==vertex_UV[0] and vUV[1]==vertex_UV[1]):
						#			if hasUV2:
						#				vUV2 = vertices_UV2s[vertex_index][index_UV]
						#				if (vUV2[0]==vertex_UV2[0] and vUV2[1]==vertex_UV2[1]):
						#					if vertices_indices[vertex_index][index_UV] >= subMeshes[materialIndex].verticesStart:
						#						alreadySaved=True
						#						break
						#			else:
						#				alreadySaved=True
						#				break
						#		index_UV+=1
						#else:
						for savedIndex in vertices_indices[vertex_index]:
							if savedIndex >= subMeshes[materialIndex].verticesStart:
								alreadySaved=True
								break
							index_UV+=1
					  
					if (alreadySaved):
						# Reuse vertex
						index=vertices_indices[vertex_index][index_UV]
					else:
						# Export new one
						index=verticesCount
						alreadySavedVertices[vertex_index]=True
						if hasUV:
							vertices_UVs[vertex_index].append(vertex_UV)
						if hasUV2:
							vertices_UV2s[vertex_index].append(vertex_UV2)
						vertices_indices[vertex_index].append(index)
						
						vertices+="%.4f,%.4f,%.4f,"%(position.x,position.z,position.y)				
						# vertices+="%.4f,%.4f,%.4f,"%(normal.x,normal.z,normal.y)
						#hasUV = len(mesh.tessface_uv_textures) > 0
						#if hasUV:
						#	UVmap = mesh.tessface_uv_textures[0].data
						#	vertices+="%.4f,%.4f,"%(UVmap[0], vertex_UV[1])
							
						#if hasUV2:
						#	vertices+="%.4f,%.4f,"%(vertex_UV2[0], vertex_UV2[1])
						
						verticesCount += 1
					faces +="%i,"%(index)
					indicesCount += 1			
					
			subMeshes[materialIndex].verticesCount = verticesCount - subMeshes[materialIndex].verticesStart
			subMeshes[materialIndex].indexCount = indicesCount - subMeshes[materialIndex].indexStart
			subMeshes[materialIndex].edgesCount = edgesCount - subMeshes[materialIndex].edgesStart
		
		hasUv = ",\"hasUV\":"
		hasUv+="%i"%(hasUV)
		hasUv+="\n"		
		
		vertices=vertices.rstrip(',')
		faces=faces.rstrip(',')
		edges=edges.rstrip(',')
		
		
		vertices+="]\n"
		faces+="]\n"	
		edges+="]\n"		
				
		# Writing mesh		
		file_handler.write("{")
		
		Export_babylon.write_string(file_handler, "name", object.name, True)		
		Export_babylon.write_string(file_handler, "id", object.name)			
		if object.parent != None:
			Export_babylon.write_string(file_handler, "parentId", object.parent.name)
		
		if len(object.material_slots) == 1:
			material = object.material_slots[0].material
			Export_babylon.write_string(file_handler, "materialId", object.material_slots[0].name)
			
			if material.game_settings.face_orientation != "BILLBOARD":
				billboardMode = 0
			else:
				billboardMode = 7
		elif len(object.material_slots) > 1:
			multimat = MultiMaterial()
			multimat.name = "Multimaterial#" + str(len(multiMaterials))
			Export_babylon.write_string(file_handler, "materialId", multimat.name)
			for mat in object.material_slots:
				multimat.materials.append(mat.name)
				
			multiMaterials.append(multimat)
			billboardMode = 0
		else:
			billboardMode = 0
			
		Export_babylon.write_vector(file_handler, "position", object.location)
		Export_babylon.write_vector(file_handler, "rotation", mathutils.Vector((0, 0, 0)))
		Export_babylon.write_vector(file_handler, "scaling", mathutils.Vector((1, 1, 1)))
		#Export_babylon.write_bool(file_handler, "isVisible", object.is_visible(scene))
		#Export_babylon.write_bool(file_handler, "isEnabled", True)
		Export_babylon.write_bool(file_handler, "checkCollisions", object.data.checkCollisions)
		#Export_babylon.write_int(file_handler, "billboardMode", billboardMode)
		Export_babylon.write_bool(file_handler, "hasUV", hasUV)
		#if hasUV and hasUV2:
		#	Export_babylon.write_int(file_handler, "uvCount", 2)
		#elif hasUV:
		#	Export_babylon.write_int(file_handler, "uvCount", 1)
		#else:
		#	Export_babylon.write_int(file_handler, "uvCount", 0)
			
		file_handler.write(vertices)	
		file_handler.write(faces)	
		file_handler.write(edges)
		file_handler.write(vertexGroups)
		
		# Sub meshes
		file_handler.write(",\"subMeshes\":[")
		first = True
		for subMesh in subMeshes:
			if first == False:
				file_handler.write(",")
			file_handler.write("{")
			Export_babylon.write_int(file_handler, "materialIndex", subMesh.materialIndex, True)
			Export_babylon.write_int(file_handler, "verticesStart", subMesh.verticesStart)
			Export_babylon.write_int(file_handler, "verticesCount", subMesh.verticesCount)
			Export_babylon.write_int(file_handler, "indexStart", subMesh.indexStart)
			Export_babylon.write_int(file_handler, "indexCount", subMesh.indexCount)
			Export_babylon.write_int(file_handler, "edgesStart", subMesh.edgesStart)
			Export_babylon.write_int(file_handler, "edgesCount", subMesh.edgesCount)
			file_handler.write("}")
			first = False
		file_handler.write("]")
		
		# Closing
		file_handler.write("}")
		

	def save(operator, context, filepath="",
		use_apply_modifiers=False,
		use_triangulate=True,
		use_compress=True):

		# Open file
		file_handler = open(filepath, 'w')	
			
		if bpy.ops.object.mode_set.poll():
			bpy.ops.object.mode_set(mode='OBJECT')		

		# Writing scene
		scene=context.scene
		
		world = scene.world
		if world:
			world_ambient = world.ambient_color
		else:
			world_ambient = Color((0.0, 0.0, 0.0))
	
		file_handler.write("{")
		file_handler.write("\"vec3dFile\":true")
		
		# Cameras
		file_handler.write(",\"cameras\":[")
		first = True
		for object in [object for object in scene.objects if object.is_visible(scene)]:
			if (object.type == 'CAMERA'):
				if first != True:
					file_handler.write(",")

				first = False
				data_string = Export_babylon.export_camera(object, scene, file_handler)
		file_handler.write("]")
						
		# Active camera
		if scene.camera != None:
			Export_babylon.write_string(file_handler, "activeCamera", scene.camera.name)
		
		# Materials
		materials = [mat for mat in bpy.data.materials if mat.users >= 1]
		file_handler.write(",\"materials\":[")
		first = True
		for material in materials:
			if first != True:
				file_handler.write(",")

			first = False
			data_string = Export_babylon.export_material(material, scene, file_handler, filepath)
		file_handler.write("]")
		
		# Meshes
		file_handler.write(",\"meshes\":[")
		multiMaterials = []
		first = True
		for object in [object for object in scene.objects]:
			if (object.type == 'MESH'):
				if first != True:
					file_handler.write(",")

				first = False
				data_string = Export_babylon.export_mesh(object, scene, file_handler, multiMaterials)
		file_handler.write("]")
		
		# Multi-materials
		file_handler.write(",\"multiMaterials\":[")
		first = True
		for multimaterial in multiMaterials:
			if first != True:
				file_handler.write(",")

			first = False
			data_string = Export_babylon.export_multimaterial(multimaterial, scene, file_handler)
		file_handler.write("]")
		
		# Closing
		file_handler.write("}")
		file_handler.close()
		
		return {'FINISHED'}

# UI
bpy.types.Mesh.checkCollisions = BoolProperty(
    name="Check collisions", 
    default = False)
	
bpy.types.Camera.checkCollisions = BoolProperty(
    name="Check collisions", 
    default = False)
	
bpy.types.Camera.applyGravity = BoolProperty(
    name="Apply Gravity", 
    default = False)	
	
bpy.types.Camera.ellipsoid = FloatVectorProperty(
    name="Ellipsoid", 
	default = mathutils.Vector((0.2, 0.9, 0.2)))		

class ObjectPanel(bpy.types.Panel):
	bl_label = "Vec3D Model Exporter"
	bl_space_type = "PROPERTIES"
	bl_region_type = "WINDOW"
	bl_context = "data"
	
	def draw(self, context):
		ob = context.object
		if not ob or not ob.data:
			return
			
		layout = self.layout
		isMesh = isinstance(ob.data, bpy.types.Mesh)
		isCamera = isinstance(ob.data, bpy.types.Camera)
		
		if isMesh:
			layout.prop(ob.data, 'checkCollisions')	
		elif isCamera:
			layout.prop(ob.data, 'checkCollisions') 
			layout.prop(ob.data, 'applyGravity') 
			layout.prop(ob.data, 'ellipsoid')
			
### REGISTER ###

def menu_func(self, context):
    self.layout.operator(Export_babylon.bl_idname, text="Vec3D Model Exporter (.vec3d)")

def register():
    bpy.utils.register_module(__name__)
    bpy.types.INFO_MT_file_export.append(menu_func)

def unregister():
    bpy.utils.unregister_module(__name__)
    bpy.types.INFO_MT_file_export.remove(menu_func)

    
if __name__ == "__main__":
    register()
