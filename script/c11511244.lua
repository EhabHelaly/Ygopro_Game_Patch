--Dragonilian Hazard
function c11511244.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511244.target)
	e1:SetOperation(c11511244.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c11511244.desop)
	c:RegisterEffect(e2)
end
function c11511244.filter(c,e,tp)
	return c:IsSetCard(0xffd) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c11511244.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11511244.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11511244.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511244.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(11511244,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c11511244.descon)
	e1:SetOperation(c11511244.desop)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	Duel.RegisterEffect(e1,tp)
end
function c11511244.desfilter(c,fid)
	return c:GetFlagEffectLabel(11511244)==fid
end
function c11511244.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g then
		if not g:IsExists(c11511244.desfilter,1,nil,e:GetLabel()) then
			g:DeleteGroup()
			e:Reset()
			return false
		else return true end
	else return false end
end
function c11511244.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if sg then 
		local dg=sg:Filter(c11511244.desfilter,nil,e:GetLabel())
		sg:DeleteGroup()
		if dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
