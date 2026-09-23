import { getSupabase } from './supabaseClient.js';
export async function signIn(email,password){
 const c=getSupabase(); if(!c) return {data:null,error:new Error('Supabase is not configured.')};
 const {data:authData,error:authError}=await c.auth.signInWithPassword({email,password});
 if(authError) return {data:null,error:authError};
 if(!authData?.user) return {data:null,error:new Error('Authentication returned no user.')};
 const {data:admin,error:adminError}=await c.from('admin_users').select('id,email,role,is_active').eq('id',authData.user.id).maybeSingle();
 if(adminError){await c.auth.signOut(); return {data:null,error:adminError};}
 if(!admin){await c.auth.signOut(); return {data:null,error:new Error('Access denied: this account is not registered as an EcoSafe administrator.')};}
 if(!admin.is_active){await c.auth.signOut(); return {data:null,error:new Error('Access denied: this EcoSafe admin account is inactive.')};}
 return {data:{user:authData.user,session:authData.session,adminProfile:admin},error:null};
}
export async function signOut(){const c=getSupabase(); if(!c) return {data:true,error:null}; return c.auth.signOut();}
export async function getSession(){const c=getSupabase(); if(!c) return {data:null,error:new Error('Supabase is not configured.')}; const {data,error}=await c.auth.getSession(); return {data:data?.session||null,error};}
export async function getCurrentUser(){const c=getSupabase(); if(!c) return {data:null,error:new Error('Supabase is not configured.')}; const {data,error}=await c.auth.getUser(); return {data:data?.user||null,error};}
export async function checkAdminAuthorization(userId){const c=getSupabase(); if(!c) return {data:null,error:new Error('Supabase is not configured.')}; const {data,error}=await c.from('admin_users').select('*').eq('id',userId).eq('is_active',true).maybeSingle(); return {data,error};}
export function onAuthStateChange(callback){const c=getSupabase(); if(!c) return {data:{subscription:{unsubscribe(){}}},error:null}; return c.auth.onAuthStateChange(callback);}
export async function changePassword(currentPassword,newPassword){ if(!currentPassword||!newPassword) return {data:null,error:new Error('Both passwords are required.')}; const c=getSupabase(); if(!c) return {data:null,error:new Error('Supabase is not configured.')}; const {data:userData,error:userError}=await c.auth.getUser(); if(userError||!userData?.user) return {data:null,error:userError||new Error('No authenticated user.')}; const {data:verify,error:verifyError}=await c.auth.signInWithPassword({email:userData.user.email,password:currentPassword}); if(verifyError) return {data:null,error:new Error('Current password is incorrect.')}; const {data,error}=await c.auth.updateUser({password:newPassword}); return {data,error}; }
