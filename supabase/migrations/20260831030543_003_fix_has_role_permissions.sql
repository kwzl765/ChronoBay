/*
# Fix has_role execution permissions

The security advisor flagged that public.has_role() is callable by the anon
role. This function is only needed by authenticated users in RLS policies.
We revoke execute from anon to close this gap.
*/

REVOKE EXECUTE ON FUNCTION public.has_role(user_role) FROM anon;
