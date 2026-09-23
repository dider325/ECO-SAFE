/** EcoSafe Bangladesh Supabase client. Public anon key only. */
import { createClient } from './supabase-bundle.js';
const getConfig=()=> (typeof window!=='undefined' && window.SUPABASE_CONFIG) ? window.SUPABASE_CONFIG : {url:'',anonKey:''};
let client=null;
export function isConfigured(){ const c=getConfig(); return Boolean(c.url && c.anonKey); }
export function getSupabase(){ if(client) return client; const c=getConfig(); if(!c.url||!c.anonKey) return null; client=createClient(c.url,c.anonKey,{auth:{persistSession:true,autoRefreshToken:true,detectSessionInUrl:true}}); return client; }
export function initSupabase(url,anonKey){ if(!url||!anonKey) throw new Error('EcoSafe Supabase URL and anon key are required.'); client=createClient(url,anonKey,{auth:{persistSession:true,autoRefreshToken:true,detectSessionInUrl:true}}); return client; }
export async function ensureClientConfigured(){ return getSupabase(); }
export const supabase=getSupabase();
